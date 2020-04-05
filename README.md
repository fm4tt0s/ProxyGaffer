# ProxyGaffer
> monitor interface IP and update MacOS system proxy based on it

## purpose

update MacOS system proxy based on machine IP

## usage

runs from crontab each N minutes, then check for utun2 IP, whenever it detects that computer is in/out a VPN, and changes system proxy configs. It can also be directly invoked for the same purpose.

### for ex, call it each 5min from cron

        */5 * * * * /Users/myself/Documents/MyAwesomeScripts/ProxyGaffer.sh /dev/null 2>&1 || true

### and options for directly invoke

        $ ./ProxyGaffer.sh 
        For directly invoke, use:

        ./ProxyGaffer.sh [help|install|uninstall|show|on|off]

        Where:
        help      :   shows this help message
        install   :   configure proxy settings on network panel
        uninstall :   remove all settings from networkpanel
        show      :   show current configs fom network panel
        on|off    :   activate/deactivate it directly

## remarks

tested only at MacOS Catalina, might work on previous versions too. you need to set below vars accordingly.

       _interface="utun2"
       _ipmatch="10"
       _conn="Wi-Fi"
       _ptypes="webproxy securewebproxy"
       _proxy="YOUR_PROXY_ADDR" 
       _port="YOUR_PROXY_ADDR_PORT" 
       _bypasslist="YOUR_PROXY_BYPASS_LIST SEPARATED BY SPACES"

## peach out!
