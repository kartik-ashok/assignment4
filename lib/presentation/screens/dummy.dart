import 'package:assignment4/presentation/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DummyScreen extends StatelessWidget {
  const DummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dummy Screen')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<PostProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (provider.error != '') {
                return Center(child: Text("Error: ${provider.error}"));
              } else if (provider.currentBooks.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          color: Colors.blueGrey,
                          // height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Book title
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    provider.currentBooks[index].title ?? "N/A",
                                    style: const TextStyle(
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.w800,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines:
                                        1, // ensures single line with ellipsis
                                    softWrap: false,
                                  ),
                                ),
                              ),

                              // Like button
                              LikeButton(
                                isLiked:
                                    provider.currentBooks[index].isFavorite,
                                onTap: () {
                                  provider.toggleFavorite(
                                    provider.currentBooks[index],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: provider.currentBooks.length,
                  ),
                );
              } else {
                return const Center(
                  child: Text("Press the button to fetch data"),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print("----");
              // Fetch data from the provider
              print(context.read<PostProvider>().loadFavorites());
              print("----");
              context.read<PostProvider>().fetchPosts();
            },
            child: const Text("Fetch Data"),
          ),
        ],
      ),
    );
  }
}

// ---------------- Like Button ----------------
class LikeButton extends StatelessWidget {
  final bool isLiked; // directly from provider
  final VoidCallback onTap; // tell provider to toggle

  const LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.white,
      ),
      onPressed: onTap,
    );
  }
}

// class LikeButton extends StatelessWidget {
//   final bool initialValue; // start state
//   final ValueChanged<bool>? onChanged; // callback when toggled
//   LikeButton({super.key, this.onChanged, required this.initialValue});

//   // each button maintains its own state using ValueNotifier
//   final ValueNotifier<bool> isLiked = ValueNotifier<bool>(false);

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: isLiked,
//       builder: (context, value, child) {
//         return IconButton(
//           icon: Icon(
//             value ? Icons.favorite : Icons.favorite_border,
//             color: value ? Colors.red : Colors.white,
//           ),
//           onPressed: () {
//             isLiked.value = !isLiked.value; // toggle like
//           },
//         );
//       },
//     );
//   }
// }
