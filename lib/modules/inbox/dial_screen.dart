import 'package:flutter/material.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/spacing_box.dart';
import 'package:datcao/themes/color.dart';

class DialScreen extends StatelessWidget {
  final List<String> names;

  const DialScreen({Key key, this.names}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptDarkColor(context),
      body: Body(names: names),
    );
  }
}

class Body extends StatefulWidget {
  final List<String> names;

  const Body({Key key, this.names}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SpacingBox(h: 3),
            Text(
              widget?.names?.join(", ")??'Calling...',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.white),
            ),
            SpacingBox(h: 0.3),
            Text(
              "Calling…",
              style: TextStyle(color: Colors.white60),
            ),
            SpacingBox(h: 3),
            DialUserPic(
              image:
                  'https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png',
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DialButton(
                  icon: Icons.volume_up,
                  text: "Audio",
                  press: () {},
                ),
                DialButton(
                  icon: Icons.mic,
                  text: "Microphone",
                  press: () {},
                ),
                DialButton(
                  icon: MdiIcons.camera,
                  text: "Video",
                  press: () {},
                ),
                // DialButton(
                //   iconSrc: "assets/icons/Icon Message.svg",
                //   text: "Message",
                //   press: () {},
                // ),
                // DialButton(
                //   iconSrc: "assets/icons/Icon User.svg",
                //   text: "Add contact",
                //   press: () {},
                // ),
                // DialButton(
                //   iconSrc: "assets/icons/Icon Voicemail.svg",
                //   text: "Voice mail",
                //   press: () {},
                // ),
              ],
            ),
            SpacingBox(h: 3),
            RoundedButton(
              iconSrc: Icons.call_end,
              press: () {
                navigatorKey.currentState.maybePop();
              },
              color: Colors.red[700],
              iconColor: Colors.white,
            ),
            SpacingBox(h: 3),
          ],
        ),
      ),
    );
  }
}

class DialButton extends StatelessWidget {
  const DialButton({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,
  }) : super(key: key);

  final String text;
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(
        vertical: 20,
      ),
      onPressed: press,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 36,
          ),
          SpacingBox(h: 1),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    this.size = 64,
    @required this.iconSrc,
    this.color = Colors.white,
    this.iconColor = Colors.black,
    @required this.press,
  }) : super(key: key);

  final double size;
  final IconData iconSrc;
  final Color color, iconColor;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(40),
      color: color,
      child: SizedBox(
        height: 63,
        width: 63,
        child: FlatButton(
          padding: EdgeInsets.all(15 / 64 * size),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          color: Colors.transparent,
          onPressed: press,
          child: Icon(
            iconSrc,
            color: iconColor,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class DialUserPic extends StatefulWidget {
  const DialUserPic({
    Key key,
    this.size = 192,
    @required this.image,
  }) : super(key: key);

  final double size;
  final String image;

  @override
  _DialUserPicState createState() => _DialUserPicState();
}

class _DialUserPicState extends State<DialUserPic>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Tween<double> _tween = Tween(begin: 0.75, end: 1);

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _tween.animate(CurvedAnimation(
          parent: _animationController, curve: Curves.decelerate)),
      child: Container(
        padding: EdgeInsets.all(23),
        height: deviceWidth(context) / 3 + 10,
        width: deviceWidth(context) / 3 + 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(0.02),
              Colors.white.withOpacity(0.05)
            ],
            stops: [.5, 1],
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          child: Image(
            image: CachedNetworkImageProvider(widget.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
