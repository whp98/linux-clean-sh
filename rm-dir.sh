#!/bin/bash
#linux定时任务步骤
#一 编辑定时任务 crontab -e
#   输入 00 06 * * * /bin/sh /home/riskuser/xrisk_job/autoExeJob.sh
#   含义：分 时 日 月 周 执行的命令【每天都执行】
#二 查看定时任务 crontab -l
#三 删除定时任务 crontab -r
workdir='/mnt/e/WIN_HOME/Desktop/linux-rm-sh'
logfile="$workdir"/rm-dir.log
skip_keywords=("0331" "0630" "0930" "1231")
for item in "$workdir"/*; do
    # 检查是否是目录
    if [ -d "$item" ]; then
        # 检查是否包含关键字
        skip=0
        for str in "${skip_keywords[@]}"; do
            if [[ $item == *$str ]]; then
                echo "$(date '+%Y-%m-%d %H:%M:%S'): skip  $item" | tee -a $logfile
                skip=1
                break
            fi
        done
        # 删除目录
        if [[ $skip -eq 0  && $item != $workdir && $item == "$workdir"* ]]; then
            #rm -rf "$item"
            echo "$(date '+%Y-%m-%d %H:%M:%S'): rm -rf $item" | tee -a $logfile
        fi
    fi
done