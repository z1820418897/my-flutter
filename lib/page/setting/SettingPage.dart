import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_seekbar/flutter_seekbar.dart'
    show ProgressValue, SectionTextModel, SeekBar;

import 'package:flutter_demo/tools/ZColors.dart';
import 'package:flutter_demo/tools/Zwidget.dart';

import 'bloc/SettingBloc.dart';
import 'bloc/SettingPrivider.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final Zwidget zw = Zwidget(); //自定义控件w
  final ZColors zc = ZColors();

  SettingBloc mSettingBloc;

  @override
  void initState() {
    super.initState();
    mSettingBloc = SettingBloc();
  }

  @override
  void dispose() {
    super.dispose();
    mSettingBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingPrivider(
      bloc: mSettingBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text("设备设置"),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              nickNameSetting(context),
              warningSetting(context),
              ringSetting(context),
              volumeSetting(context),
              disturbSetting(context),
              deleteDevice(context),
            ],
          ),
        ),
      ),
    );
  }

  //向右箭头
  Widget rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      size: 35.0,
      color: zc.primaryColor(context),
    );
  }

  //设置昵称
  Container nickNameSetting(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          print("你好世界");
        },
        child: zw.ZCard(
          child: ListTile(
            title: zw.ZText("设备昵称"),
            subtitle: zw.ZText("郑华晨的设备", 12),
            trailing: rightIcon(),
            leading: Icon(
              Icons.home,
              size: 35.0,
              color: zc.primaryColor(context),
            ),
          ),
        ),
      ),
    );
  }

  //设置智能人体报警
  Container warningSetting(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          print("你好世界");
        },
        child: StreamBuilder(
          stream: mSettingBloc.mWarningStream,
          initialData: false,
          builder: (context, async) {
            return zw.ZCard(
              child: ListTile(
                title: zw.ZText("智能人体报警"),
                subtitle: zw.ZText(async.data ? "打开" : "关闭", 12),
                trailing: Switch(
                  value: async.data,
                  onChanged: (state) {
                    mSettingBloc.setWarningState(state);
                  },
                ),
                leading: Icon(
                  Icons.ac_unit,
                  size: 35.0,
                  color: zc.primaryColor(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  int i = 1;

  //铃声设置
  Container ringSetting(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          mSettingBloc.setRingState(i);
          i++;
          if (i == 4) {
            i = 0;
          }
        },
        child: StreamBuilder(
          stream: mSettingBloc.mRingStream,
          initialData: 1,
          builder: (context, async) {
            String str;
            switch (async.data) {
              case 1:
                str = "叮当";
                break;
              case 2:
                str = "咚咚";
                break;
              case 3:
                str = "哐当";
                break;
              default:
                str = "";
            }
            return zw.ZCard(
              child: ListTile(
                title: zw.ZText("铃声控制"),
                subtitle: zw.ZText(str, 12),
                trailing: rightIcon(),
                leading: Icon(
                  Icons.ac_unit,
                  size: 35.0,
                  color: zc.primaryColor(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //音量设置
  Container volumeSetting(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {},
        child: StreamBuilder(
          stream: null,
          initialData: 1,
          builder: (context, async) {
            return zw.ZCard(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: zw.ZText("音量控制"),
                    subtitle: StreamBuilder(
                        stream: mSettingBloc.mVolumeStream,
                        initialData: 80,
                        builder: (context, snapshot) {
                          return Text("音量：${snapshot.data}");
                        }),
                    trailing: Container(
                      child: StreamBuilder(
                          stream: mSettingBloc.mVolumeStateStream,
                          initialData: false,
                          builder: (context, snapshot) {
                            String str = "设置";
                            if (snapshot.data) {
                              str = "保存";
                            } else {
                              str = "设置";
                            }

                            return OutlineButton(
                              onPressed: () {
                                mSettingBloc.setVolumeState(!snapshot.data);
                              },
                              child: Text(str),
                            );
                          }),
                    ),
                    leading: Icon(
                      Icons.ac_unit,
                      size: 35.0,
                      color: zc.primaryColor(context),
                    ),
                  ),
                  StreamBuilder<Object>(
                      stream: mSettingBloc.mVolumeStateStream,
                      initialData: false,
                      builder: (context, snapshot) {
                        return Visibility(
                          visible: snapshot.data,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 40.0,
                                right: 40.0,
                                top: 10.0,
                                bottom: 40.0),
                            child: SeekBar(
                              progresseight: 10,
                              value: mSettingBloc.mVolume.toDouble(),
                              sectionTextSize: 10,
                              showSectionText: true,
                              onValueChanged: (value) {
                                print(value.value);
                                var ceil = value.value.ceil();
                                mSettingBloc.setVolume(ceil);
                              },
                            ),
                          ),
                        );
                      }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //免打扰设置
  Container disturbSetting(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {},
        child: StreamBuilder(
          stream: mSettingBloc.mDisturbStream,
          initialData: false,
          builder: (context, async) {
            return zw.ZCard(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: zw.ZText("免打扰"),
                    leading: Icon(
                      Icons.ac_unit,
                      size: 35.0,
                      color: zc.primaryColor(context),
                    ),
                    trailing: Switch(
                      value: async.data,
                      onChanged: (state) {
                        mSettingBloc.setDisturbState(state);
                      },
                    ),
                    subtitle: StreamBuilder(
                        stream: mSettingBloc.mDisturbStream,
                        initialData: mSettingBloc.disturbState,
                        builder: (context, snapshot) {
                          String str = "关闭";
                          if (snapshot.data) {
                            str = "开启";
                          } else {
                            str = "关闭";
                          }

                          return zw.ZText(str, 12);
                        }),
                  ),
                  StreamBuilder(
                      stream: mSettingBloc.mDisturbStream,
                      initialData: false,
                      builder: (context, snapshot) {
                        return Visibility(
                          visible: snapshot.data,
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                              children: <Widget>[
                                Text("日期选择"),
                                StreamBuilder(
                                    stream: mSettingBloc.mWeekStream,
                                    initialData: mSettingBloc.mWeeks,
                                    builder: (context, snapshot) {
                                      return Container(
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            //横轴元素个数
                                            crossAxisCount: 4,
                                            //纵轴间距
                                            mainAxisSpacing: 0.0,
                                            //横轴间距
                                            crossAxisSpacing: 0.0,
                                            //子组件宽高长度比例
                                            childAspectRatio: 1.5,
                                          ),
                                          physics:
                                              new NeverScrollableScrollPhysics(),
                                          //增加
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index) {
                                            List<String> items = [
                                              "一",
                                              "二",
                                              "三",
                                              "四",
                                              "五",
                                              "六",
                                              "日"
                                            ];
                                            return Row(
                                              children: <Widget>[
                                                Checkbox(
                                                  value: snapshot.data[index],
                                                  onChanged: (state) {
                                                    mSettingBloc.setWeeks(
                                                        state, index);
                                                  },
                                                ),
                                                Text("${items[index]}")
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                StreamBuilder(
                                    stream: mSettingBloc.mDateStream,
                                    initialData: [],
                                    builder: (context, snapshot) {
                                      return Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            OutlineButton(
                                              child: zw.ZText("开始时间"),
                                              onPressed: () {
                                                DatePicker.showTimePicker(
                                                  context,
//                                    onChanged: (date){print("change $date");},
                                                  onConfirm: (date) {
                                                    var beginTime = [
                                                      date.hour,
                                                      date.minute,
                                                      date.second
                                                    ];
                                                    print("change $beginTime");
                                                    mSettingBloc.setDate(
                                                        DateType.begin,
                                                        beginTime);
                                                  },
                                                );
                                              },
                                            ),
                                            Container(
                                              color: zc.primaryColor(context),
                                              width: 20.0,
                                              height: 2.0,
                                            ),
                                            OutlineButton(
                                              child: zw.ZText("结束时间"),
                                              onPressed: () {
                                                DatePicker.showTimePicker(
                                                  context,
//                                    onChanged: (date){print("change $date");},
                                                  onConfirm: (date) {
                                                    var overTime = [
                                                      date.hour,
                                                      date.minute,
                                                      date.second
                                                    ];
                                                    print("change $overTime");
                                                    mSettingBloc.setDate(
                                                        DateType.over,
                                                        overTime);
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                StreamBuilder<Object>(
                                    stream: mSettingBloc.mDateStream,
                                    initialData: [],
                                    builder: (context, snapshot) {
                                      var beginTime = mSettingBloc.mbeginTime;
                                      var overTime = mSettingBloc.mOverTime;

                                      var begin = [];
                                      var over = [];

                                      beginTime.forEach((date) => begin.add(
                                          date > 9 ? "${date}" : "0${date}"));
                                      overTime.forEach((date) => over.add(
                                          date > 9 ? "${date}" : "0${date}"));

                                      String msg = null;
                                      if (overTime[0] < beginTime[0]) {
                                        msg = "次日";
                                      }

                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.0),
                                        child: zw.ZText(
                                            "从 ${begin[0]}:${begin[1]}:${begin[2]} - ${msg != null ? msg : ""}${over[0]}:${over[1]}:${over[2]} 你将不会收到该设备呼叫",
                                            15.0,
                                            FontWeight.w400),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //删除设备
  Container deleteDevice(BuildContext context) {
    return Container(
        margin:
            EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0, bottom: 50.0),
        child: OutlineButton(
          onPressed: () {
            print("你好世界");
          },
          child:
              Container(padding: EdgeInsets.all(12.0), child: zw.ZText("删除设备")),
        ));
  }

}
