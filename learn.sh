#!/bin/bash

header_cookie="Cookie: "
sleep_time=30


# 以下变量不需要设置
header_accept="Accept: application/json, text/javascript, */*; q=0.01"
header_accept_language="Accept-Language: zh-CN,zh;q=0.9"
header_Origin="Origin: http://cqlgcj.sccchina.net/"
header_referer_a="Referer: https://cqlgcj.sccchina.net/"
header_Referer="Referer: http://cqlgcj.sccchina.net/student/videolearning.html"
header_content_type="Content-Type: application/json"
header_user_agent="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"
header_x_Requested_with="X-Requested-With: XMLHttpRequest"
header_metadataCode="metadataCode: Student_StudentHome"

function rand16() {
  length=16 # 指定小数的长度
  random_bytes=$(od -An -N"$length" -t u1 /dev/urandom | tr -d ' ')
  random_decimal="0.$random_bytes"
}

function recordStudyTimes() {
  rand16
  curl 'http://cqlglms.sccchina.net/venus/common/recordStudyTimes.do' \
    -H 'Accept: */*' \
    -H 'Accept-Language: zh-CN,zh;q=0.9' \
    -H 'CeduAjax: 1' \
    -H 'Connection: keep-alive' \
    -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
    -H 'Cookie: CEDU_G_USER_FLAG=ea27a958-159d-4b86-8b43-83c3405d081a$1758528135960200203-0000-0000-0000-0; JSESSIONID=F8F83DEEE5BE440CD02EF6B8A25C54D2' \
    -H 'Origin: http://cqlglms.sccchina.net' \
    -H 'Referer: http://cqlglms.sccchina.net/venus/study/activity/webpage/studyCourseware.do?userCourseId=1776707613454500875-0000-0000-0000-0&courseVersionId=1690184481193852938-0000-0000-0000-0&courseActivityId=d16f8217-705b-4b60-b569-8cd8f0eed461&trainCourseId=1754259052770099211-0000-0000-0000-0&url=http%3A%2F%2Ffjshare.chinaedu.net%2Fcourse%2FcourseWare.do%3ForgCode%3D010245%26courseCode%3D00805%26userId%3D3039FC9F9275F7EC0A652B7DBF4B0565%26timestamp%3D1694486457253%26sign%3D821CCE0A65E988788DCA1C47C8C3DA42%26connectionPlayKey%3D1758528135960200203_1690184481193852938%26teachingVersion%3D1690184481193852938%26protocolType%3Dnull%26centerId%3D310a6333da3f4019afd7332bfd76a1b4&urlType=1' \
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \
    -H 'X-Requested-With: XMLHttpRequest' \
    --data-raw "userCourseId=1776707613454500875-0000-0000-0000-0&rand=${random_decimal}" \
    --compressed \
    --insecure

}

function record() {
  rand16
  curl 'http://cqlglms.sccchina.net/venus/study/activity/webpage/record.do' \
    -H 'Accept: */*' \
    -H 'Accept-Language: zh-CN,zh;q=0.9' \
    -H 'CeduAjax: 1' \
    -H 'Connection: keep-alive' \
    -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
    -H 'Cookie: CEDU_G_USER_FLAG=e401e914-9e74-4a3f-b057-04280f89e013$1758528135960200203-0000-0000-0000-0; JSESSIONID=D2DE03FCD27DA514D8DF6857A91C65C9' \
    -H 'Origin: http://cqlglms.sccchina.net' \
    -H 'Referer: http://cqlglms.sccchina.net/venus/study/activity/webpage/studyCourseware.do?userCourseId=1776707613454500875-0000-0000-0000-0&courseVersionId=1690184481193852938-0000-0000-0000-0&courseActivityId=d16f8217-705b-4b60-b569-8cd8f0eed461&trainCourseId=1754259052770099211-0000-0000-0000-0&url=http%3A%2F%2Ffjshare.chinaedu.net%2Fcourse%2FcourseWare.do%3ForgCode%3D010245%26courseCode%3D00805%26userId%3D3039FC9F9275F7EC0A652B7DBF4B0565%26timestamp%3D1694487348625%26sign%3D9D49F6FAC13C181240C6D168458BCAA6%26connectionPlayKey%3D1758528135960200203_1690184481193852938%26teachingVersion%3D1690184481193852938%26protocolType%3Dnull%26centerId%3D702270960701491294244640857965a2&urlType=1' \
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \
    -H 'X-Requested-With: XMLHttpRequest' \
    --data-raw "id=021dcae1-1ccd-4fc8-8569-00435b52c6fb&userCourseId=1776707613454500875-0000-0000-0000-0&trainCourseId=1754259052770099211-0000-0000-0000-0&courseVersionId=1690184481193852938-0000-0000-0000-0&courseActivityId=d16f8217-705b-4b60-b569-8cd8f0eed461&learnSessionId=&length=180&rand=${random_decimal}" \
    --compressed \
    --insecure
}
function passBackCourseWareDuration() {
  curl 'http://fjshare.chinaedu.net/course/passBackCourseWareDuration.do?randomData=5841&orgCode=010245&courseCode=00805&userId=3039FC9F9275F7EC0A652B7DBF4B0565&cid=c4e6c2fa262eb197962353e9a780cf9fe1ac4d16&pos=3.507142&connectionPlayKey=1758528135960200203_1690184481193852938' \
    -H 'Accept: */*' \
    -H 'Accept-Language: zh-CN,zh;q=0.9' \
    -H 'Connection: keep-alive' \
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \
    -H 'X-Requested-With: XMLHttpRequest' \
    --compressed \
    --insecure
}
function main(){
  echo "开始课件学习"
    for (( ; ; )); do
        finished=0
        # 获取课程进度
        curl_courst_list=$(curl -s -L -X POST 'https://cqlgcj.sccchina.net/student/student/coursestudy/getlist' -H "${header_accept}" -H "${header_accept_language}" -H "${header_content_type}" -H "${header_cookie}" -H  "${header_Origin}" -H "${header_user_agent}" -H "${header_x_Requested_with}" -H "${header_metadataCode}" -H "${header_referer_a}" --data '{"data":"aggregation"}')

        # 如果cookie失效
        test "$curl_courst_list" = "RedirectToLogin" && {
          echo "cookie已失效"
            exit 1
        }
        echo  "${curl_courst_list}" | grep "301 Moved Permanently" >/dev/null 2>&1 && {
            echo "cookie已失效"
            exit 1
        }

        courst_list_length=$(echo "$curl_courst_list" | jq '.items | length')
        for ((i = 0; i < courst_list_length; i++)); do
            course_name=$(echo "$curl_courst_list" | jq -r ".items[$i].courseName")
            # course_id=$(echo "$curl_courst_list" | jq -r ".items[$i].courseVersionID")
            # course_progress=$(echo "$curl_courst_list" | jq ".items[$i].realCoursewarePlayTime" | tr -d " " | tr -d "\"")
            # course_progress_current=$(echo "$course_progress" | cut -d "/" -f1)

            # course_progress_current_compare=$(echo "$course_progress_current" | cut -d "." -f1)

            # 对比方式:状态
            courseware_play_num=$(echo "$curl_courst_list" | jq ".items[$i].realCoursewarePlayNum")
            current_count=$(echo "${courseware_play_num}"  | grep -oE '[0-9]+' | head -n1 )  
            count=$(echo "${courseware_play_num}"  | grep -oE '[0-9]+' | tail -n1 )  

            test "$current_count" -ge "$count" && {
                echo "课程名:${course_name} 状态: 学习完毕"
                finished=$((finished + 1))
                continue
            }
            practice_use_flag=$(echo "$curl_courst_list" | jq ".items[$i].practiceUseFlag")
            test "$practice_use_flag" = "true" && {
              echo "课程名:${course_name} 状态:未完成 学习进度:${current_count}/${count}"
                finished=$((finished + 1))
                continue
            }

        done
        test "$finished" = "$courst_list_length" && {
            echo 所有课程学习完毕
            exit 0
        }
        echo "挂起${sleep_time}秒"
        sleep ${sleep_time}
    done

}

main