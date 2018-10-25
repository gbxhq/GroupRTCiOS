用WebRTC实现iOS端的多方通话

<!---more--->

开发历史

> 2018.09.12 周三

- 开始。

  之前编译有问题。王卫老师重写了一份给我。

  调用SocketRocket库连接到服务器上。连接成功。

> 09.13 周四

- 给服务器发json格式的NSString对象。服务器没有反应。

  每次都是发送了message给服务器之后，才输出WebSocket Connected。

  把发送message放到webSocketDidOpen之后发。成功。

> 09.14 周五

- 初级界面问题。ViewControler里想用Appdelegate的对象。我只能调Appdelegate的方法。

> 09.17 周一

- 调AppDelegate的问题解决了。原来是服务器格式要求json包里有个字母要大写。细心啊！

> 09.18 周二

- 改变核心任务。先打通信令！

- 可以离开房间关闭socket了。最简单的加入和离开可以之后。要做逻辑复杂的PeerConnection和RoomManager了。

> 09.19 周三

- 在AppDelegate中创建Participate对象。将客户端发送和接受用的方法全部在写Appdelegate。

  ViewControler使用时再调用。

- 字典存放Participate类对象

> 09.20 周四

- 今天效率比较高。写代码很顺。对照Kurento的js文件。客户端与服务器交互的信令基本打通。
- 剩下最坑的就是调官方库的时候了。
- 一直接不到participantLeft的信令。找了强哥。看服务器的Java代码。最后发现不建立RTCPeer是不给我发这条信令的。

> 09.25 周二

- 中秋小假归来。今天先看官方Demo: APPRTC。

> 09.26 周三

- Participate类中加入了PeerConnection和ICECandidate。有问题，ICecandidate初始化懵了。脑子有点乱。

> 09.27 周四

- 准备将发送的包从NSString转成NSData，先试一下服务器那边能不能处理NSDate。
  - 失败。发Data就只能发Data。反而费事了。老老实实用String吧。发String只是Dictionary转String稍微多几句。
- 开始研究调用官方库，多次尝试运行报错。

> 09.28 周五

- framework的库不会使用。网上下到一个.a的库，报错

> 10.08 周一

- 国庆归来

- 研究.a静态库的编译，参考这篇文章https://www.jianshu.com/p/2ecb9d846b35

  发现我手上的这份源码好像不支持，在`webrtc_build/webrtc/src/tools_webrtc/ios/build_ios_libs.py `文件的配置选项里没有`static_only`

  开始编译Framework。编译好发现不会导入到工程里用。import不出来。放到子目录里可以`#import "WebRTC.framework/Headers/xxx.h"`，但这样肯定不正宗啊！

> 10.09 周二

- 终于会用WebRTC.framework了。两个要点：

  - 直接把WebRTC.framework拖到Embbded Binaries

  - > `#import "WebRTC/RTCVideoTrack.h" ` 这么引入就可以。——王卫老师

    我折腾了这么多天都知道是这么引用的😂 确实，人家官方的APPRTC demo不就是这样引入的吗？终于可以开工了。

> 10.17 周三

- 调用官方库后参考多个iOS Demo，没有实质进展。

  因为参考Kurento官方的js版代码，核心文件逻辑复杂。

- 今天开始，我也封装一个RTCPeerConnectionClient。

  未来的几天就干这个事。

