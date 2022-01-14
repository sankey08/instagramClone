class User{
  String name;
  String avatar;
  User({
    required this.name,
    required this.avatar,
  });
}

class Post{
  User user;
  String image;
  String caption;
  int likeCount;
  bool viewComments;
  List<Comment> comments;
  Post({
    required this.user,
    required this.image,
    required this.caption,
    this.likeCount = 0,
    this.viewComments = false,
    required this.comments,
  });
}

class Comment{
  User user;
  String text;
  Comment({
    required this.user,
    required this.text
  });
}

List<User> users = [
  User(name: "Sanket",avatar:"https://i.pravatar.cc/80?img=4"),
  User(name: "Pranav",avatar:"https://i.pravatar.cc/80?img=2"),
  User(name: "Nikhil",avatar:"https://i.pravatar.cc/80?img=3"),
  User(name: "Chinmayee",avatar:"https://i.pravatar.cc/80?img=1"),
  User(name: "Hrushikesh",avatar:"https://i.pravatar.cc/80?img=5"),
];

User me = users[0];
List<User> following = [me];

List<Post> posts = [
  Post(user: users[0], image: "https://picsum.photos/401", caption: "Mera pehle post", comments: [
    Comment(user: users[1],text : "Pehle comment"),
  ], likeCount: 55),
 
];

int selectedMenuIndex = 0;