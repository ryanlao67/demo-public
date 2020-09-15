# submit mediaconvert job
# 1300
./submit-job.sh 8 1300000 s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/1300/ s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-mp4/FDNB5509593/1300/flow.mp4 HIGH
# 2300
./submit-job.sh 8 2300000 s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/2300/ s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-mp4/FDNB5509593/2300/flow.mp4 HIGH
# 400
./submit-job.sh 6 400000 s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/400/ s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-mp4/FDNB5509593/400/flow.mp4 MAIN
# 4000
./submit-job.sh 8 4000000 s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/4000/ s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-mp4/FDNB5509593/4000/flow.mp4 HIGH
# 6000
./submit-job.sh 8 6000000 s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/6000/ s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-mp4/FDNB5509593/6000/flow.mp4 HIGH
# 700
./submit-job.sh 6 700000 s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/700/ s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-mp4/FDNB5509593/700/flow.mp4 MAIN


# converted ts to local
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/1300/flowss.ts FDNB5509593/1300/flowss.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/2300/flowss.ts FDNB5509593/2300/flowss.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/400/flowss.ts FDNB5509593/400/flowss.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/4000/flowss.ts FDNB5509593/4000/flowss.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/6000/flowss.ts FDNB5509593/6000/flowss.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/700/flowss.ts FDNB5509593/700/flowss.ts

# ffmpeg segment
# 1300
ffmpeg -i FDNB5509593/1300/flowss.ts -c copy -f ssegment -segment_time 10 -initial_offset -0.56 -segment_start_number 1 -individual_header_trailer 0 FDNB5509593/1300/flow%04d.ts
# 2300
ffmpeg -i FDNB5509593/2300/flowss.ts -c copy -f ssegment -segment_time 10 -initial_offset -0.56 -segment_start_number 1 -individual_header_trailer 0 FDNB5509593/2300/flow%04d.ts
# 400
ffmpeg -i FDNB5509593/400/flowss.ts -c copy -f ssegment -segment_time 10 -initial_offset -0.56 -segment_start_number 1 -individual_header_trailer 0 FDNB5509593/400/flow%04d.ts
# 4000
ffmpeg -i FDNB5509593/4000/flowss.ts -c copy -f ssegment -segment_time 10 -initial_offset -0.56 -segment_start_number 1 -individual_header_trailer 0 FDNB5509593/4000/flow%04d.ts
# 6000
ffmpeg -i FDNB5509593/6000/flowss.ts -c copy -f ssegment -segment_time 10 -initial_offset -0.56 -segment_start_number 1 -individual_header_trailer 0 FDNB5509593/6000/flow%04d.ts
# 700
ffmpeg -i FDNB5509593/700/flowss.ts -c copy -f ssegment -segment_time 10 -initial_offset -0.56 -segment_start_number 1 -individual_header_trailer 0 FDNB5509593/700/flow%04d.ts


# local cp to s3
aws s3 cp FDNB5509593 s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593 --recursive

# remove merged ts on s3
aws s3 rm s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/1300/flowss.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/2300/flowss.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/400/flowss.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/4000/flowss.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/6000/flowss.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593/700/flowss.ts

# convert folder sync to mixed
aws s3 sync s3://poc-data-zhy-ryanlao/opg-mediaconvert/convert/FDNB5509593 s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593

# replace origin ts in mixed folder
# 1300
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-ts/FDNB5509593/1300/flow0002.ts s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593/1300/flow0002.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-ts/FDNB5509593/1300/flow0004.ts s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593/1300/flow0004.ts
# 2300
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-ts/FDNB5509593/2300/flow0002.ts s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593/2300/flow0002.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-ts/FDNB5509593/2300/flow0004.ts s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593/2300/flow0004.ts
# 400
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-ts/FDNB5509593/400/flow0002.ts s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593/400/flow0002.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-ts/FDNB5509593/400/flow0004.ts s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593/400/flow0004.ts
# 4000
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-ts/FDNB5509593/4000/flow0002.ts s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593/4000/flow0002.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-ts/FDNB5509593/4000/flow0004.ts s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593/4000/flow0004.ts
# 6000
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-ts/FDNB5509593/6000/flow0002.ts s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593/6000/flow0002.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-ts/FDNB5509593/6000/flow0004.ts s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593/6000/flow0004.ts
# 700
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-ts/FDNB5509593/700/flow0002.ts s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593/700/flow0002.ts
aws s3 cp s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-ts/FDNB5509593/700/flow0004.ts s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5509593/700/flow0004.ts

# 动画-鼠来宝
http://cdn.yc-wgr.cn/convert/FDNB5483879/1300/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5483879/2300/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5483879/400/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5483879/4000/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5483879/6000/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5483879/700/flow.m3u8

# 电影-哥斯拉2
http://cdn.yc-wgr.cn/convert/FDNB5509593/1300/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5509593/2300/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5509593/400/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5509593/4000/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5509593/6000/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5509593/700/flow.m3u8

# 新闻-香港新冠
http://cdn.yc-wgr.cn/convert/FDNB5542044/1300/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542044/2300/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542044/400/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542044/4000/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542044/6000/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542044/700/flow.m3u8

# 新闻-媒体大搜索1
http://cdn.yc-wgr.cn/convert/FDNB5515013/1300/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5515013/2300/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5515013/400/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5515013/4000/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5515013/6000/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5515013/700/flow.m3u8

# 新闻-媒体大搜索2
http://cdn.yc-wgr.cn/convert/FDNB5542050/1300/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542050/2300/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542050/400/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542050/4000/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542050/6000/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542050/700/flow.m3u8

# 新闻-体育新闻
http://cdn.yc-wgr.cn/convert/FDNB5542171/1300/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542171/2300/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542171/400/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542171/4000/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542171/6000/flow.m3u8
http://cdn.yc-wgr.cn/convert/FDNB5542171/700/flow.m3u8

