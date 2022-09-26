import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PostsProvider with ChangeNotifier {
  List<Map<String, dynamic>>? _posts = [];
  List<String>? _categories = ["none"];

  List<Map<String, dynamic>> get posts {
    return _posts!;
  }

  List<String> get categories {
    return _categories!;
  }

  Future<void> filterPosts(String userId, String category) async {
    final db = FirebaseFirestore.instance;
    _posts = [];

    db.collection("posts").where("category", isEqualTo: category).where("owner", isEqualTo: userId).get().then(
      (doc) async {
        if (category != "none") {
          doc.docs.forEach((element) {
            _posts!.add(element.data());
          });
          notifyListeners();
        } else {
          await db.collection("posts").where("owner", isEqualTo: userId).get().then((event) {
            for (var doc in event.docs) {
              _posts!.add({
                "id": doc.id,
                "title": doc.data()['title'],
                "body": doc.data()['body'],
                "category": doc.data()['category'],
                "image": doc.data()['image'],
              });
              notifyListeners();
            }
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void fillPosts(String userId) {
    final db = FirebaseFirestore.instance;

    db.collection("posts").where("owner", isEqualTo: userId).snapshots().listen((event) {
      _posts = [];

      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
              _posts!.add({
                "id": change.doc.id,
                "title": change.doc.data()!['title'],
                "body": change.doc.data()!['body'],
                "category": change.doc.data()!['category'],
                "image": change.doc.data()!['image'],
              });
            break;
          case DocumentChangeType.modified:
            print("Modified City: ${change.doc.data()}");
            break;
          case DocumentChangeType.removed:
            print("Removed City: ${change.doc.data()}");
            break;
        }
      }

      notifyListeners();
    });
  }

}
