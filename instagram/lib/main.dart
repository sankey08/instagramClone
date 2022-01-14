import 'package:flutter/material.dart';
import 'data.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> pages = [Feed(),Search(),Profile(),PostImage()];
  @override
  Widget build(BuildContext context) {
    // Switching users (testing code)
    // me = users[3];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("GoInsta",style: TextStyle(color: Colors.black, fontFamily: "Courier",fontWeight: FontWeight.bold,fontSize: 20),),
            Text(me.name,style: TextStyle(color: Colors.black, fontFamily: "Courier",fontWeight: FontWeight.bold,fontSize: 20),),
          ],
        )
        ),
        body: pages[selectedMenuIndex],
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.pink,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedMenuIndex,
          onTap: (value){
            setState(() {
              selectedMenuIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "search"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "person"),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "add_circle"),
          ],),
    );
  }
}


class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  TextEditingController _commentController = TextEditingController();
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
          children: [
            for(Post post in posts)
            if(following.contains(post.user))
           Container(
             child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
               padding: EdgeInsets.symmetric(horizontal:10),
              child: Row(children: [
                CircleAvatar(
                  // backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(post.user.avatar),
                ),
                SizedBox(width : 10),
                Text(post.user.name,style: TextStyle(
                  fontWeight: FontWeight.bold,
                  ),)
              ],),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal:10),
              child: Image.network("https://picsum.photos/400",
              errorBuilder: (c,e,s){
                // If error occurs place an alternate placeholder
                return Placeholder(
                  fallbackWidth: 450,
                  fallbackHeight: 300,
                );
              },)
              ),
          Container(
              padding: EdgeInsets.symmetric(horizontal:10),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Row(
                children: [
                  MaterialButton(onPressed: () {
                    setState(() {
                      post.likeCount++;
                      isLiked = true;
                    });
                  }, minWidth:0, child: Icon(Icons.favorite, color: isLiked ? Colors.red : Colors.grey,)),
                  SizedBox(width: 5),
                  Text("${post.likeCount} Likes")
                  ],
                ),
              Row(
                children: [
                  Text("${post.comments.length} Comments"),
                  MaterialButton(onPressed: () {
                    setState(() {
                      //toggle
                      post.viewComments = !post.viewComments;                      
                    });
                  },minWidth: 0,child: Icon(Icons.chat_bubble_outline))
                ],
              )
              ]
              ,),),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.symmetric(horizontal:10),
              child: Text(post.caption,style: TextStyle(
                fontSize: 18,
              ),),),
          if(post.viewComments)
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                for(Comment comment in post.comments)
                Row(
                  children: [
                    Text(comment.user.name,style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(width : 5), 
                    Text(comment.text),
                  ],
                ),
              ],
            ),
          ),
          if(post.viewComments)
          Container(
            padding: EdgeInsets.symmetric(horizontal:10),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                hintText: "Write a comment!",
                suffix: MaterialButton(onPressed: () {
                  setState(() {
                    Comment newComment = Comment(user: me,text: _commentController.text);
                    post.comments.add(newComment);
                    _commentController.text = "";
                  });
                },minWidth: 0,child: Icon(Icons.send),),
                ),
            ),
          ),
              Divider(),
        ],),
           ),],);
  }
}

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  //Need a controller
  TextEditingController _searchController = TextEditingController();
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Users",
                  suffix: MaterialButton(onPressed: () {
                    setState(() {
                      searchText = _searchController.text;
                    });
                  },
                  child: Icon(Icons.search),),
                ),
              ),
              for(User user in users)
              if(user!=me && user.name.contains(searchText))
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                color: Colors.white, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Row(
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(user.avatar), ),
                      SizedBox(width:10),
                      Text(user.name)
                    ],
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        if(following.contains(user)){
                          following.remove(user);
                        }
                        else{
                          following.add(user);
                        }
                      });
                    }, 
                    child: following.contains(user) ? Text("Following" ,style: TextStyle(color: Colors.green),) : Text("Follow"),
                    )
                ],),
              )
            ],
          ),
        ),
    );
  } 
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child : ListView(
        children: [
          Container(
            color: Colors.grey,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${me.name}'s posts",
                  style: TextStyle(fontSize: 20,color: Colors.black), 
                  ),
                
                  Text(
                    posts.where((element) => element.user == me).length.toString() + " posts",style: TextStyle(color: Colors.white),)
              ],
            ),
          ),
          CircleAvatar(backgroundImage: NetworkImage(me.avatar),radius: 80,),
          SizedBox(height:10),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              for(Post post in posts)
              Image.network(
                post.image,
                errorBuilder: (c,e,s){
                // If error occurs place an alternate placeholder
                return Placeholder(
                  fallbackWidth: 450,
                  fallbackHeight: 300,
                );
              },
              ),
            ],
          ),
      ],),
    );
  }
}

class PostImage extends StatefulWidget {
  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  TextEditingController _imageController = TextEditingController();
  String imagePath = "";
  TextEditingController _captionController = TextEditingController();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _avatarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          Text("Create a post", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
          TextField(
            controller: _imageController,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: "Image Path ..",
              suffix: MaterialButton(onPressed: () {
                setState(() {
                  imagePath = _imageController.text;
                });
              }, 
              child: Icon(Icons.check),)
            ),
          ),
           TextField(
             controller: _captionController,
            decoration: InputDecoration(
              hintText: "Caption!",
            ),
          ),
          SizedBox(height:10),
          if(imagePath!="") Image.network(imagePath, 
          errorBuilder: (c,e,s){
                // If error occurs place an alternate placeholder
                return Placeholder(
                  fallbackWidth: 450,
                  fallbackHeight: 300,
                );
              },),
            MaterialButton(onPressed: (){
              setState(() {
                Post newPost = Post(
                  user: me,
                  image: imagePath,
                  caption: _captionController.text,
                  comments: []
                );
                posts.add(newPost);
                _imageController.text = "";
                _captionController.text = "";
                imagePath = "";
              });
            },
            minWidth: double.infinity,
            color: Colors.pink,
            child: Text(
              "Post Image", style : TextStyle(color: Colors.white,)),
              ),
              SizedBox(height: 40),
              Text("Create a User", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              TextField(
                controller: _usernameController,
                autocorrect: false,
                 decoration: InputDecoration(
                  hintText: "Username!",
                ),
              ),
              TextField(
                controller: _avatarController,
                autocorrect: false,
                 decoration: InputDecoration(
                  hintText: "Avatar!",
                 ),
              ),
              SizedBox(height: 10),
              MaterialButton(
                onPressed: (){
                  setState(() {
                    User newUser = User(
                        name : _usernameController.text,
                        avatar: _avatarController.text,
                    );
                    users.add(newUser);
                    _usernameController.text = "";
                    _avatarController.text = "";

                  });
                },
                 minWidth: double.infinity,
                 color: Colors.pink,
                 child: Text(
                   "Add User", style : TextStyle(color: Colors.white,)),
                  ),
        ],
      )
    );
  }
}