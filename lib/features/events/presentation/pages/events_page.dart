import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/event.dart';
import '../bloc/events_bloc.dart';
import '../bloc/events_event.dart';
import '../bloc/events_state.dart';
import '../widgets/event_card.dart';
import '../widgets/category_chip.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'All';
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<EventsBloc>().add(const FeaturedEventsLoadRequested());
    context.read<EventsBloc>().add(const CategoriesLoadRequested());
    context.read<EventsBloc>().add(const EventsLoadRequested());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<EventsBloc>().state;
      if (state is EventsLoaded && !state.hasReachedMax) {
        context.read<EventsBloc>().add(EventsLoadRequested(
          page: state.currentPage + 1,
          category: state.category,
          search: state.search,
          loadMore: true,
        ));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFeaturedSection(),
          _buildCategoriesSection(),
          Expanded(child: _buildEventsList()),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return BlocBuilder<EventsBloc, EventsState>(
      buildWhen: (previous, current) => current is FeaturedEventsLoaded,
      builder: (context, state) {
        if (state is FeaturedEventsLoaded && state.events.isNotEmpty) {
          return SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                return _FeaturedEventCard(event: event);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCategoriesSection() {
    return BlocBuilder<EventsBloc, EventsState>(
      buildWhen: (previous, current) => current is CategoriesLoaded,
      builder: (context, state) {
        if (state is CategoriesLoaded) {
          return SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                CategoryChip(
                  label: 'All',
                  isSelected: _selectedCategory == 'All',
                  onTap: () => _onCategorySelected('All'),
                ),
                ...state.categories.map((category) => CategoryChip(
                  label: category.name,
                  isSelected: _selectedCategory == category.name,
                  onTap: () => _onCategorySelected(category.name),
                )),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEventsList() {
    return BlocBuilder<EventsBloc, EventsState>(
      buildWhen: (previous, current) => 
        current is EventsLoaded || 
        current is EventsLoading || 
        current is EventsError,
      builder: (context, state) {
        if (state is EventsLoading && !state.isLoadMore) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EventsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<EventsBloc>().add(const EventsRefreshRequested()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is EventsLoaded) {
          if (state.events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery != null 
                        ? 'No events found for "$_searchQuery"'
                        : 'No events available',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<EventsBloc>().add(const EventsRefreshRequested());
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: state.events.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index == state.events.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final event = state.events[index];
                return EventCard(
                  event: event,
                  onTap: () => context.push('/events/${event.id}'),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _searchQuery = null;
    });
    
    if (category == 'All') {
      context.read<EventsBloc>().add(const EventsLoadRequested());
    } else {
      context.read<EventsBloc>().add(EventsFilterByCategoryRequested(categoryId: category));
    }
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: _EventSearchDelegate(
        onSearch: (query) {
          setState(() {
            _searchQuery = query;
            _selectedCategory = 'All';
          });
          context.read<EventsBloc>().add(EventsSearchRequested(query: query));
        },
      ),
    );
  }
}

class _FeaturedEventCard extends StatelessWidget {
  final Event event;

  const _FeaturedEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/events/${event.id}'),
          child: Stack(
            children: [
              if (event.bannerUrl != null)
                CachedNetworkImage(
                  imageUrl: event.bannerUrl!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.event),
                  ),
                )
              else
                Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: const Center(child: Icon(Icons.event, size: 48)),
                ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.venueName,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(event.startDate),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

class _EventSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;

  _EventSearchDelegate({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}