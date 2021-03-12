import 'package:flutter/material.dart';
import './detail_media.dart';

class MediaGroupWidgetCache extends StatelessWidget {
  final List<String> paths;

  const MediaGroupWidgetCache({Key key, @required this.paths})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (paths.length == 1) {
      return SizedBox(
        width: double.infinity,
        height: (MediaQuery.of(context).size.width * 0.7) / 1.75,
        child: MediaWidgetCache(
          path: paths[0],
        ),
      );
    }
    if (paths.length == 2) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: (MediaQuery.of(context).size.width * 0.7) / 2,
              child: MediaWidgetCache(
                path: paths[0],
              ),
            ),
          ),
          SizedBox(
            width: 3,
          ),
          Expanded(
            child: SizedBox(
              width: (MediaQuery.of(context).size.width * 0.7) / 2 - 1.5,
              height: (MediaQuery.of(context).size.width * 0.7) / 2,
              child: MediaWidgetCache(
                path: paths[1],
              ),
            ),
          ),
        ],
      );
    }
    if (paths.length == 3) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: (MediaQuery.of(context).size.width * 0.7) / 2,
            child: MediaWidgetCache(
              path: paths[0],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 2.5,
                  child: MediaWidgetCache(
                    path: paths[1],
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 2.5,
                  child: MediaWidgetCache(
                    path: paths[2],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    if (paths.length == 4) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: (MediaQuery.of(context).size.width * 0.7) / 2,
            child: MediaWidgetCache(
              path: paths[0],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetCache(
                    path: paths[1],
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetCache(
                    path: paths[2],
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width * 0.7) / 3 - 2,
                height: (MediaQuery.of(context).size.width * 0.7) / 3,
                child: MediaWidgetCache(
                  path: paths[3],
                ),
              ),
            ],
          ),
        ],
      );
    }
    if (paths.length == 5) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 2,
                  child: MediaWidgetCache(
                    path: paths[0],
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 2,
                  child: MediaWidgetCache(
                    path: paths[1],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetCache(
                    path: paths[2],
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetCache(
                    path: paths[3],
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetCache(
                    path: paths[4],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (paths.length > 5) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 2,
                  child: MediaWidgetCache(
                    path: paths[0],
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 2,
                  child: MediaWidgetCache(
                    path: paths[1],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetCache(
                    path: paths[2],
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetCache(
                    path: paths[3],
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: Stack(
                    children: [
                      SizedBox(
                        width:
                            (MediaQuery.of(context).size.width * 0.7) / 3 - 2,
                        height: (MediaQuery.of(context).size.width * 0.7) / 3,
                        child: MediaWidgetCache(
                          path: paths[4],
                        ),
                      ),
                      IgnorePointer(
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width * 0.7) / 3 - 2,
                          height: (MediaQuery.of(context).size.width * 0.7) / 3,
                          color: Colors.black45,
                        ),
                      ),
                      IgnorePointer(
                        child: Center(
                          child: Text(
                            '+' + (paths.length - 4).toString(),
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }
}

class MediaGroupWidgetNetwork extends StatelessWidget {
  final List<String> urls;

  const MediaGroupWidgetNetwork({Key key, @required this.urls})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final callBack = (int index) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return DetailMediaGroupWidget(
          files: urls,
          index: index,
        );
      }));
    };
    if (urls.length == 1) {
      return SizedBox(
        width: double.infinity,
        height: (MediaQuery.of(context).size.width * 0.7) / 1.75,
        child: MediaWidgetNetwork(
          file: urls[0],
          callBack: () => callBack(0),
        ),
      );
    }
    if (urls.length == 2) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: (MediaQuery.of(context).size.width * 0.7) / 2,
              child: MediaWidgetNetwork(
                file: urls[0],
                callBack: () => callBack(0),
              ),
            ),
          ),
          SizedBox(
            width: 3,
          ),
          Expanded(
            child: SizedBox(
              width: (MediaQuery.of(context).size.width * 0.7) / 2 - 1.5,
              height: (MediaQuery.of(context).size.width * 0.7) / 2,
              child: MediaWidgetNetwork(
                file: urls[1],
                callBack: () => callBack(1),
              ),
            ),
          ),
        ],
      );
    }
    if (urls.length == 3) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: (MediaQuery.of(context).size.width * 0.7) / 2,
            child: MediaWidgetNetwork(
              file: urls[0],
              callBack: () => callBack(0),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 2.5,
                  child: MediaWidgetNetwork(
                    file: urls[1],
                    callBack: () => callBack(1),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 2.5,
                  child: MediaWidgetNetwork(
                    file: urls[2],
                    callBack: () => callBack(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    if (urls.length == 4) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: (MediaQuery.of(context).size.width * 0.7) / 2,
            child: MediaWidgetNetwork(
              file: urls[0],
              callBack: () => callBack(0),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetNetwork(
                    file: urls[1],
                    callBack: () => callBack(1),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetNetwork(
                    file: urls[2],
                    callBack: () => callBack(2),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width * 0.7) / 3 - 2,
                height: (MediaQuery.of(context).size.width * 0.7) / 3,
                child: MediaWidgetNetwork(
                  file: urls[3],
                  callBack: () => callBack(3),
                ),
              ),
            ],
          ),
        ],
      );
    }
    if (urls.length == 5) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 2,
                  child: MediaWidgetNetwork(
                    file: urls[0],
                    callBack: () => callBack(0),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 2,
                  child: MediaWidgetNetwork(
                    file: urls[1],
                    callBack: () => callBack(1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetNetwork(
                    file: urls[2],
                    callBack: () => callBack(2),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetNetwork(
                    file: urls[3],
                    callBack: () => callBack(3),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetNetwork(
                    file: urls[4],
                    callBack: () => callBack(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (urls.length > 5) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 2,
                  child: MediaWidgetNetwork(
                    file: urls[0],
                    callBack: () => callBack(0),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 2,
                  child: MediaWidgetNetwork(
                    file: urls[1],
                    callBack: () => callBack(1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetNetwork(
                    file: urls[2],
                    callBack: () => callBack(2),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: MediaWidgetNetwork(
                    file: urls[3],
                    callBack: () => callBack(3),
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.7) / 3,
                  child: Stack(
                    children: [
                      SizedBox(
                        width:
                            (MediaQuery.of(context).size.width * 0.7) / 3 - 2,
                        height: (MediaQuery.of(context).size.width * 0.7) / 3,
                        child: MediaWidgetNetwork(
                          file: urls[4],
                          callBack: () => callBack(4),
                        ),
                      ),
                      IgnorePointer(
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width * 0.7) / 3 - 2,
                          height: (MediaQuery.of(context).size.width * 0.7) / 3,
                          color: Colors.black45,
                        ),
                      ),
                      IgnorePointer(
                        child: Center(
                          child: Text(
                            '+' + (urls.length - 4).toString(),
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }
}
