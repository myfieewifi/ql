#!/bin/bash
set -e

get_step(){
stty erase ^?
echo -e "-----孟云-----
\n0.退出\n1.修复白屏问题(支持最高v2.11.1版)\n2.还原白屏修复前初始index.html文件\n3.查看index.html文件\n4.去仓库找回对应index.html原文件(仅v2.10.6版-最新版)\n5.修复PC端脚本管理等界面空白问题(先修复完白屏，再执行)
\n-----SUIYUE-----"

read -r -p "请输入数字：" input
	case $input in
0)
exit
;;

1)
if [[ ! -s /ql/dist/index.html ]] && [[ ! -s /ql/static/dist/index.html ]]; then
    echo "未检测到index.html文件或未处于青龙环境内部，请使用bash进入青龙容器内部再执行，勿用sh进入"
    exit 1
fi
echo "###1、检测青龙版本开始###"
while [ -z `echo ${QL_BRANCH#*v} | egrep "(([0-9]|([1-9]([0-9]*))).){2}([0-9]|([1-9]([0-9]*)))"` ]
do
  echo "未检测到青龙版本号，请手动指定,输入exit可退出"
  read -r -p "请输入版本号:" QL_BRANCH
  if [ "${QL_BRANCH}" == "exit" ]; then
    exit 1
  fi
done
  echo "当前青龙版本：$QL_BRANCH"

V_NOW=${QL_BRANCH#*v}
V_GREAT=2.11.1
if test "$(echo $V_NOW $V_GREAT | tr " " "\n" | sort -V | head -n 1)" != "$V_NOW"; then
  echo "当前青龙高于v2.11.1版无需修复"
  exit 1
fi

echo "###2、开始修复白屏###"
if [ ! -s /ql/dist/index.html.bak ]; then
  if [ -s /ql/static/dist/index.html ]; then
    echo "检测到当前为高版本青龙，不支持修复"
    exit 1
  else
    cp /ql/dist/index.html /ql/dist/index.html.bak
    echo "####2、1备份index.html文件完成####"
  fi
fi

echo "####2、2开始下载js.tar.gz文件到/ql/dist"
wget -t 5 https://ghproxy.com/raw.githubusercontent.com/myfieewifi/ql/main/js/js.tar.gz -P /ql/dist

echo "####2、3解压js.tar.gz文件到/ql/dist/js"
tar -zxvf /ql/dist/js.tar.gz -C /ql/dist

echo "###3、修改index.html文件###"

sed -i 's#https://.*/react/16.*/umd/react.production.*.js#/js/react.production.min.js#g' "/ql/dist/index.html"
sed -i 's#https://.*/react-dom/16.*/umd/react-dom.production.*.js#/js/react-dom.production.min.js#g' "/ql/dist/index.html"
sed -i 's#https://.*/darkreader@4.*/darkreader.*.js#/js/darkreader.min.js#g' "/ql/dist/index.html"
sed -i 's#https://.*/codemirror@5.*/lib/codemirror.*.js#/js/codemirror.min.js#g' "/ql/dist/index.html"
sed -i 's#https://.*/codemirror@5.*/mode/shell/shell.js#/js/shell.js#g' "/ql/dist/index.html"
sed -i 's#https://.*/codemirror@5.*/mode/python/python.js#/js/python.js#g' "/ql/dist/index.html"
sed -i 's#https://.*/codemirror@5.*/mode/javascript/javascript.js#/js/javascript.js#g' "/ql/dist/index.html"
sed -i 's#https://.*/sockjs-client@1.*/dist/sockjs.*.js#/js/sockjs.min.js#g' "/ql/dist/index.html"

echo "###4、删除js.tar.gz压缩包###"
rm -vf /ql/dist/js.tar.gz*

echo -e "\n###恭喜你，白屏修复操作完成，请查看index.html文件，如若修复不成功，请先执行步骤4找回对应版本的index.html文件再重试###\n"
echo -e "提醒：
PC端打开【配置文件、脚本管理】出现白屏，请执行选项5，可彻底修复所有问题！(旧版钉子户的福音来啦！)

也可以进行如下操作，临时修复，但部分功能无法使用！
（1）浏览器按F12键，打开开发者工具界面后，切换到移动端模式(快捷键：ctrl+shift+M)，刷新一下即可！！！
（2）加载出来后，可以关闭开发者工具，但关闭开发者界面后，每次刷新都需要重复步骤（1）\n"
;;

2)
echo "###开始还原初始index.html文件###"
if [ -s /ql/dist/index.html.bak ]; then
  cp /ql/dist/index.html.bak /ql/dist/index.html
  echo "还原初始文件成功"
else
  echo "修复前未备份index.html文件，无法进行还原"
fi
;;

3)
echo "查看当前index.html内容"
if [ ! -s /ql/dist/index.html ]; then
  if [ ! -s /ql/static/dist/index.html ]; then
    echo "未检测到index.html文件或未处于青龙环境内部，请使用bash进入青龙容器内部再执行，勿用sh进入"
    exit 1
  else
    cat /ql/static/dist/index.html
  fi
else
  cat /ql/dist/index.html
fi
;;

4)
clear
if [[ ! -d /ql/dist ]] && [[ ! -d /ql/static/dist ]]; then
    echo "未检测到dist目录或未处于青龙环境内部，请使用bash进入青龙容器内部再执行，勿用sh进入"
    exit 1
fi

echo "###1、检测青龙版本开始###"
while [ -z `echo ${QL_BRANCH#*v} | egrep "(([0-9]|([1-9]([0-9]*))).){2}([0-9]|([1-9]([0-9]*)))"` ]
do
  echo "未检测到青龙版本号，请手动指定,输入exit可退出"
  read -r -p "⚠️请务必准确输入版本号，否则会出错：" QL_BRANCH
  if [ "${QL_BRANCH}" == "exit" ]; then
    exit 1
  fi
done
  echo "当前青龙版本：$QL_BRANCH"

V_NOW=${QL_BRANCH#*v}
V_LESS=2.10.6
if test "$(echo $V_NOW $V_LESS | tr " " "\n" | sort -rV | head -n 1)" != "$V_NOW"; then
  echo "当前青龙版本过低，远程仓库没有对应版本的html文件，请自行解决！切勿强行操作！"
  exit 1
fi

read -r -p "警告⚠️：你已进入高危操作，请输入y确定！" input
    case $input in

y)
if [ -d /ql/dist ]; then
DIR=/ql/dist
else
DIR=/ql/static/dist
fi

function download_html() {
echo "强制删除index.html文件"
rm -rf $DIR/index.html
echo "开始从qinglong仓库远程恢复index.html文件到$DIR"
wget -t 5 -N https://raw.gh.fakev.cn/whyour/qinglong-static/v${QL_BRANCH#*v}/dist/index.html -P $DIR/
echo -e "远程恢复index.html文件完成，请查看index.html文件\n"
}

echo -e "开始恢复index.html文件"
if [ -s $DIR/index.html.bak1 ]; then
  read -r -p "检测到本地备份文件，如若web界面出错！请尝试输入y来恢复原文件，回车跳过本地恢复：" input
      case $input in

y)
echo "进行本地index.html恢复"
cp $DIR/index.html.bak1 $DIR/index.html
echo -e "本地index.html恢复完成，请查看index.html文件\n"
;;

*)
download_html
;;
esac

elif [ -s $DIR/index.html ]; then
read -r -p "备份当前index.html文件，防止web界面出错！如不需要，请输入n取消" input
  if [ "${input}" != "n" ]; then
     echo "备份当前的index.html，以便后期恢复"
     cp $DIR/index.html $DIR/index.html.bak1
     download_html
  else
    download_html
  fi
else
  download_html
fi
;;

*)
echo "未进一步确认，即将退出该操作！"
;;
esac
;;

5)
echo "###1、开始修复PC端部分界面空白问题###"
if [[ ! -d /ql/dist ]] && [[ ! -d /ql/static/dist ]]; then
    echo "未检测到dist目录或未处于青龙环境内部，请使用bash进入青龙容器内部再执行，勿用sh进入"
    exit 1
fi

echo "###2、检测青龙版本开始###"
while [ -z `echo ${QL_BRANCH#*v} | egrep "(([0-9]|([1-9]([0-9]*))).){2}([0-9]|([1-9]([0-9]*)))"` ]
do
  echo "###3、未检测到青龙版本号，请手动指定,输入exit可退出"
  read -r -p "请输入版本号：" QL_BRANCH
  if [ "${QL_BRANCH}" == "exit" ]; then
    exit 1
  fi
done
  echo "当前青龙版本：$QL_BRANCH"

V_NOW=${QL_BRANCH#*v}
V_GREAT=2.11.1
if test "$(echo $V_NOW $V_GREAT | tr " " "\n" | sort -V | head -n 1)" != "$V_NOW" ||[ -s /ql/static/dist/index.html ] ; then
  echo "当前青龙版本过高，即将退出操作"
  exit 1
fi

URL_OLD=https://cdn.jsdelivr.net/npm/monaco-editor@0.28.1/min/vs
URL_NEW=https://cdn.staticfile.org/monaco-editor/0.28.1/min/vs
function amend_url() {
STATE_1=""
FIND_FILE=/ql/dist/p__$1.*.js
FIND=`basename $FIND_FILE`
if [ -z "`grep "$FIND_SIR" $FIND_FILE`" ]; then
  if [[ -z "`grep "$URL_OLD" $FIND_FILE`" ]] && [[ -z "`grep "$URL_NEW" $FIND_FILE`" ]]; then
  echo -e "❌检测到$FIND文件的链接已被非法篡改，请自行恢复原文件，或重装容器后再试！\n"
  STATE_1=0
  else
    echo -e "⚠️未检测到$FIND文件存在该链接，已进行过修改操作， 本次不再进行重复操作！\n"
    STATE_1=0
  fi
else
  echo "$FIND文件存在链接，进行修改！"
  if [ "${FIND_SIR}" == "${URL_OLD}" ]; then
    sed -i 's#https://cdn.jsdelivr.net/npm/monaco-editor@0.28.1/min/vs#https://cdn.staticfile.org/monaco-editor/0.28.1/min/vs#g' "/ql/dist/$FIND"
  else
    sed -i 's#https://cdn.staticfile.org/monaco-editor/0.28.1/min/vs#https://cdn.jsdelivr.net/npm/monaco-editor@0.28.1/min/vs#g' "/ql/dist/$FIND"
  fi
echo -e "打包修改后的js文件"
gzip -c /ql/dist/$FIND > /ql/dist/$FIND.gz
echo -e "✅文件打包成功！\n"
fi
}

echo -e "\n0.返回主菜单\n1.修改替换js文件(解决白屏)\n2.还原初始js文件(恢复原样)"
read -r -p "请选择：" input
      case $input in

0)
;;

1)
echo "开始修改替换js文件"
FIND_SIR=$URL_OLD
echo "###3、检测js文件是否存在https://cdn.jsdelivr.net链接并进行修改###"
amend_url config__index
amend_url diff__index
amend_url log__index
amend_url script__index
amend_url script__editModal

if [ "${STATE_1}" != "0" ]; then
echo -e "恭喜你！PC端白屏问题已彻底修复完成；
请仔细查看日志，5个文件是否都被修改成功
请使用chrome内核浏览器访问ctrl＋F5刷新浏览器界面\n"
fi
;;

2)
FIND_SIR=$URL_NEW
echo "###3、检测js文件是否存在https://cdn.staticfile.org链接并进行还原###"
amend_url config__index
amend_url diff__index
amend_url log__index
amend_url script__index
amend_url script__editModal

if [ "${STATE_1}" != "0" ]; then
echo -e "恭喜你！还原初始js文件成功\n"
fi
;;

*)
echo "请输入正确！"
;;
esac
;;

*)
echo "请输入正确"
;;
esac
get_step
}

get_step "$@"
