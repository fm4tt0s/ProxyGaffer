# ProxyGaffer
> monitor interface IP and update MacOS system proxy based on it

## purpose

update MacOS system proxy based on machine IP

## usage

runs from crontab each N minutes, then check for utun2 IP, whenever it detects that computer is in/out a VPN, and changes system proxy configs. It can also be directly invoked for the same purpose.

## remarks

tested only at MacOS Catalina, might work on previous versions too. you need to set below vars accordingly.

    _interface="utun2"
    _ipmatch="10"
    _conn="Wi-Fi"
    _ptypes="webproxy securewebproxy"
    _proxy="YOUR_PROXY_ADDR" 
    _port="YOUR_PROXY_ADDR_PORT" 
    _bypasslist="YOUR_PROXY_BYPASS_LIST SEPARATED BY SPACES"
