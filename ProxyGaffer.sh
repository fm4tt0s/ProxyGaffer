#!/usr/bin/env bash
#
# author    : Felipe Mattos
# email     : fmattos@gmx.com
# date      : 03/27/2020
# version   : 0.1
#
# purpose   : update MacOS system proxy based on machine IP
# usage     : runs from crontab each N minutes, then check for utun2 IP, whenever it detects that computer is in/out VPN,
#           changes system proxy configs. It can also be directly invoked for the same purpose.
# remarks   : tested only at MacOS Catalina, might work on previous versions too
#
# changelog
#

# vars
# int to monitor
_interface="utun2"
# ip to match - as matched on, address : 10.11.12.13 - address.*${_ipmatch}\.[0-9]
_ipmatch="10"
# connection name
_conn="Wi-Fi"
# proxy types - grab the ones you use - webproxy securewebproxy ftpproxy socksfirewallproxy streamingproxy gopherproxy
_ptypes="webproxy securewebproxy"
_proxy="YOUR_PROXY_ADDR" 
_port="YOUR_PROXY_ADDR_PORT" 
_bypasslist="YOUR_PROXY_BYPASS_LIST SEPARATED BY SPACES"

show_help() {
    echo "For directly invoke, use:"
    echo
    echo "${0} [help|install|uninstall|show|on|off]"
    echo
    echo "Where:"
    echo "help      :   shows this help message"
    echo "install   :   configure proxy settings on network panel"
    echo "uninstall :   remove all settings from networkpanel"
    echo "show      :   show current configs fom network panel"
    echo "on|off    :   activate/deactivate it directly"
    echo
    exit 1
}

# non interactive execution
if [[ ! -t 0 ]]; then
    set -x
    if /usr/sbin/scutil --nwi "${_interface}" | grep "address.*${_ipmatch}\.[0-9]" ; then
        [[ -f /tmp/proxywatcher.lock ]] && exit 0
        touch /tmp/proxywatcher.lock
        _action="on"
    else
        [[ ! -f /tmp/proxywatcher.lock ]] && exit 0
        rm -rf /tmp/proxywatcher.lock
        _action="off"
    fi
else
    # interactive execution
    [[ -z "${1}" ]] && show_help || _action="${1}"
fi

while [[ -n "${_action}" ]]; do
    case "${_action}" in
    false)
        exit 0
    ;;
    help)
        show_help
    ;;
    install|uninstall)
        _oper="set"
        [[ "${_action}" == "install" ]] && _action="false"
        [[ "${_action}" == "uninstall" ]] && _proxy="Empty" && _bypasslist="Empty" && _port="Empty" && _action="off"
        for i in $_ptypes; do
            /usr/sbin/networksetup -"${_oper}${i}" "${_conn}" "${_proxy}" "${_port}"
        done
        /usr/sbin/networksetup -setproxybypassdomains "${_conn}" "${_bypasslist}"
    ;;
    show)
        _oper="get"
        for i in $_ptypes; do
            echo "${i}:"
            /usr/sbin/networksetup -"${_oper}${i}" "${_conn}" | tr '\n' '\t' ; echo
        done
        echo "bypass list: "
        /usr/sbin/networksetup -getproxybypassdomains "${_conn}" | tr '\n' ' ' ; echo
        _action="false"
    ;;
    on|off)
        _oper="set"
        [[ "${_action}" == "on" ]] && touch /tmp/proxywatcher.lock
        [[ "${_action}" == "off" ]] && rm -rf /tmp/proxywatcher.lock && _bypasslist="Empty"
        for i in $_ptypes; do
            /usr/sbin/networksetup -"${_oper}${i}state" "${_conn}" "${_action}"
        done
            /usr/sbin/networksetup -setproxybypassdomains "${_conn}" "${_bypasslist}"
        _action="false"
    ;;
    *)
        show_help
        _action="false"
    ;;
    esac
done
