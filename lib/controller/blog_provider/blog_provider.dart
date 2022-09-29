import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../model/post.dart';

class PostsProvider with ChangeNotifier {
  List<Post>? _posts = [];
  List<String>? _categories = ["none"];
  bool _postsEmpty = false;
  Post? _postDetail =
      Post(id: '', title: '', body: '', category: '', image: '');

  Post? get postDetail {
    return _postDetail;
  }

  List<Post>? get posts {
    return _posts!;
  }

  List<String> get categories {
    return _categories!;
  }

  bool get postEmpty {
    return _postsEmpty;
  }

  getPostDetails(String postId) {
    print({'GET DETAILS', postId});
    final db = FirebaseFirestore.instance;

    print('GET DETAILS 2');

    final docRef = db.collection("posts").doc(postId);

    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        _postDetail = Post(
          id: doc.id,
          title: data['title'],
          body: data["body"],
          category: data["category"],
          image: data["image"],
        );

        print('DETAIL GET');
        notifyListeners();
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  Future<void> filterPosts(String userId, String category) async {
    final db = FirebaseFirestore.instance;
    _posts = [];

    db
        .collection("posts")
        .where("category", isEqualTo: category)
        .where("owner", isEqualTo: userId)
        .get()
        .then(
      (doc) async {
        if (category != "none") {
          doc.docs.forEach((element) {
            _posts!.add(
              Post(
                id: element.id,
                title: element.data()['title'],
                body: element.data()['body'],
                category: element.data()['category'],
                image: element.data()['image'],
              ),
            );
          });

          if (_posts!.isEmpty) {
            _postsEmpty = true;
          }

          notifyListeners();
        } else {
          await db
              .collection("posts")
              .where("owner", isEqualTo: userId)
              .get()
              .then((event) {
            for (var doc in event.docs) {
              _posts!.add(
                Post(
                  id: doc.id,
                  title: doc.data()['title'],
                  body: doc.data()['body'],
                  category: doc.data()['category'],
                  image: doc.data()['image'],
                ),
              );
            }

            if (_posts!.isEmpty) {
              _postsEmpty = true;
            }

            notifyListeners();
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void fillPosts(String userId) {
    final db = FirebaseFirestore.instance;

    db
        .collection("posts")
        .where("owner", isEqualTo: userId)
        .snapshots()
        .listen((event) {
      _posts = [];

      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            _posts!.add(
              Post(
                id: change.doc.id,
                title: change.doc.data()!['title'],
                body: change.doc.data()!['body'],
                category: change.doc.data()!['category'],
                image: change.doc.data()!['image'],
              ),
            );
            break;
          case DocumentChangeType.modified:
            print("Modified City: ${change.doc.data()}");
            break;
          case DocumentChangeType.removed:
            print("Removed City: ${change.doc.data()}");
            break;
        }
      }

      if (_posts!.isEmpty) {
        _postsEmpty = true;
      }

      notifyListeners();
    });
  }
}
