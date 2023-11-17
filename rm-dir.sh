#!/bin/bash
#linux定时任务步骤
#一 编辑定时任务 crontab -e
#   输入 00 06 * * * /bin/sh /home/riskuser/xrisk_job/autoExeJob.sh
#   含义：分 时 日 月 周 执行的命令【每天都执行】
#二 查看定时任务 crontab -l
#三 删除定时任务 crontab -r
# 获取当前日期
current_date=$(date +%Y%m%d)
# 计算最近一个月的起始日期
last_month_start=$(date -d "$current_date -1 month" +%Y%m%d)
last_year_start=$(date -d "$current_date -1 year" +%Y%m%d)
workdir='/mnt/e/MY_CODE/Shell/linux-clean-sh'
logfile="$workdir"/rm-dir.log
skip_keywords=("0331" "0630" "0930" "1231")
skip_keywords_all_month=("0131" "0228" "0229" "0331" "0430" "0530" "0630" "0731" "0831" "0930" "1031" "1130" "1231")
for item in "$workdir"/*; do
    item_name=$(basename "$item")
    # 检查是否是目录
    if [ -d "$item" ]; then
        # 检查是否包含关键字
        skip=0
        for str in "${skip_keywords[@]}"; do
            if [[ $item == *$str ]]; then
                echo "$(date '+%Y-%m-%d %H:%M:%S'): skip season end $item" | tee -a $logfile
                skip=1
                break
            fi
        done
        # 判断目标日期是否在最近一个月中
        if [[ $skip -eq 0 && "$item_name" -ge "$last_month_start" && "$item_name" -le "$current_date" ]]; then
            skip=1
            echo "$(date '+%Y-%m-%d %H:%M:%S'): $item is in a month,skip it" | tee -a $logfile
        fi
        # 判断目标日期是否在最近一个年中且在月末排除中
        if [[ $skip -eq 0 && "$item_name" -ge "$last_year_start" && "$item_name" -le "$current_date" ]]; then
            for str1 in "${skip_keywords_all_month[@]}"; do
                if [[ $item == *$str1 ]]; then
                    echo "$(date '+%Y-%m-%d %H:%M:%S'): skip widthin last year month end $item" | tee -a $logfile
                    skip=1
                    break
                fi
            done
        fi
        # 删除目录
        if [[ $skip -eq 0  && $item != $workdir && $item == "$workdir"* ]]; then
            #rm -rf "$item"
            echo "$(date '+%Y-%m-%d %H:%M:%S'): rm -rf $item" | tee -a $logfile
        fi
    fi
done