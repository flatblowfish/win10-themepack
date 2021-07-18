############################################################
# 1. 下载网页
############################################################
#
curl https://support.microsoft.com/en-us/windows/desktop-themes-94880287-6046-1d35-6d2f-35dee759701e#ID0EDD=Windows_10 -o download.html
#
############################################################
# 2. 获取下载链接，去重，保存
############################################################
#
cat download.html | gawk 'BEGIN {RS="@$@"; FS="ID0EDD-supTabControlContent"} {print $2}' | grep "<a href=\"https://download.microsoft.com/download" | gawk 'BEGIN{FS="\""} {print $2}' | sort | uniq > url.txt
#
############################################################
# 3. 下载文件
############################################################
#
unset download_url
download_url[0]=''
count=1
while read line; do
    download_url[${count}]="${line}"
    count=$[${count} + 1]
done < url.txt
count=$[${count} - 1]
echo "数组元素个数为: $((${#download_url[@]}-1))"
echo "第一个链接：${download_url[1]}"
echo "最后一个链接：${download_url[${count}]}"

mkdir -p downloads
rm -rf download-fail.log
for (( i=1; i <= ${count}; i++ )); do
    echo "${i}. downloading \"${download_url[${i}]}\""
    echo ${i} > download-cur.log
    wget ${download_url[${i}]} -P downloads
    if [ $? -ne 0 ]; then
        echo "${i}. wget ${download_url[${i}]}" >> download-fail.log
    fi
done
