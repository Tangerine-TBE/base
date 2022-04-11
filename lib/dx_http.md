#### **DXHttp(Dio封装)  功能：缓存、文件下载，实现Stream方式(缓存)、Callback方式的Dio封装处理。支持多域名的，各域继承抽象类DXHttp配置各自属性(单例)。**
```
//子类继承example:
class DemoHttp extends DXHttp {
  ///实现单例
  static DemoHttp _instance = DemoHttp._init();

  factory DemoHttp.instance() => _instance;

  DemoHttp._init() {
    super.init();
  }

  ///显示加载弹窗
  @override
  void showLoading() {}

  ///关闭加载弹窗
  @override
  void dismissLoading() {}

  @override
  DXHttpConfig initConfig() => DXHttpConfig(
        'http://www.baidu.con', //请求域名
        isProxy: false, //是否设置代理
        proxyAddress: "192.168.x.x", //设置请求代理地址
        proxyHost: "8888", //设置请求代理端口号
        successCode: 200, //response--请求成功code
        codeStr: 'code',//response--解析code key
        msgStr: "message",//response--解析message key
        isPrintLog: false,//是否输出日志--拦截器
        isDebugPrint: true, //是否输出日志--debugPrint
        baseHeader: {},//默认请求头
        interceptors: [], //请求拦截器
        cacheSum : 50, //总共缓存多少条数据
        ignoreKey :  const [], //缓存key--忽略的参数名
      );

  ///统一onError处理,判断code处理各error
  @override
  void defaultError(String msg, int code, bool isErrorToast, OnError? onError) {
    // showToast();
  }
}
```
CallBacK方式：主要用于Post做提交操作，默认Post请求+展示loading弹窗。

```
  //Callback方式
  DemoHttp.instance().requestOnCallBack(
    path: 'path', //required
    onSuccess: (Map<String, dynamic> map) {}, //成功回调，required
    params: {}, 
    method: RequestMethod.POST, //callback:default=POST
    onError: (String msg, int code) {}, //错误回调
    isShowLoading: true, //是否展示loading,callback:default=true
    isNeedSave: false, //是否需要缓存,callback:default=false
    isErrorToast: true,//onError是否自动弹msg Toast,default=true
    // formData:  //post表单上传文件
  );
```
Steam方式：主要配合StreamBuilder用于需要先加载网络请求的页面，默认使用缓存。若缓存不为空，先yield缓存数据，请求完成后yield请求数据。返回ResponseBean对象。

CacheSteamBuilder:封装空布局、网络错误布局、加载布局、下拉刷新、缓存。
```
  //Stream方式 
   var stream = DemoHttp.instance().requestOnStream(
    path: 'path',
    params: {},
    method: RequestMethod.GET, //Stream:default=GET
    isNeedCache: true, //Stream:default=true
  );
  StreamBuilder<ResponseBean>(
    stream: stream,
    builder: (context, snapshot) {
      //请求成功Widget
      if (snapshot.connectionState == ConnectionState.done &&
          snapshot.data != null) {
        var map = snapshot.data!.map;
        return Container();
      }
      return Container();
    },
  );
```
