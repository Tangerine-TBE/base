***DX_Plugin*** 自用封装及工具类集合
 - **DXHttp(Dio封装)**  

```
//example:  
class DemoHttp extends DXHttp {  
///实现单例  
static DemoHttp _instance = DemoHttp._init();

factory DemoHttp.instance() => _instance;

DemoHttp._init() {  
super.init();  
}

///初始配置  
@override  
DXHttpConfig initConfig() => DXHttpConfig(  
‘[http://www.baidu.con](http://www.baidu.con/)’, //请求域名  
isProxy: true, //是否设置代理  
proxyAddress: “192.168.x.x”, //设置请求代理地址  
proxyHost: “8888”, //设置请求代理端口号  
successCode: 200, //response–请求成功code  
codeStr: ‘code’, //response–解析code key  
msgStr: “message”, //response–解析message key  
isPrintLog: false, //debug是否打印请求日志  
baseHeader: {}, //默认请求头  
interceptors: [], //请求拦截器  
);

///显示加载弹窗  
@override  
void showLoading() {}

///关闭加载弹窗  
@override  
void dismissLoading() {}

///统一onError处理  
@override  
void customError(String msg, int code, bool isErrorToast) {}  
} 

```
