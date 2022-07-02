# ql
青龙面板

#一键添加依赖脚本
1.进入容器

docker exec -it qinglong bash

2.执行脚本文件

curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/myfieewifi/ql/main/dependence/QLDependency.sh | sh

#青龙白屏修复脚本
1.进入容器

docker exec -it qinglong bash

2.执行脚本文件
bash <(curl -ls https://raw.fastgit.org/myfieewifi/ql/main/bpxf/bpxf.sh)
