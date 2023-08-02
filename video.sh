#!/bin/bash
# 刷新每个科目之间的间隔时间,默认30,再高其实没用
sleep_time=30

# cookie的作用就不用解释了吧
header_cookie="Cookie: " 

# 上传学习进度的的进度值,其实除了设置成任何值都没有用
studyDuration="30"

# 以下变量不需要设置
header_accept="Accept: application/json, text/javascript, */*; q=0.01"
header_accept_language="Accept-Language: zh-CN,zh;q=0.9"
header_Origin="Origin: http://cqlgcj.sccchina.net/"
header_Referer="Referer: http://cqlgcj.sccchina.net/student/videolearning.html"
header_content_type="Content-Type: application/json"
header_user_agent="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"
header_x_Requested_with="X-Requested-With: XMLHttpRequest"
header_metadataCode="metadataCode: Student_StudentHome"
header_studentversion_video="metadataCode: StudentVersion_Video"

function init() {
    os=$(uname)
    case $os in
    # macOS基本命令检测
    Darwin)
        which curl >/dev/null 2>&1 || {
            log "准备安装curl命令,具体命令"
            brew install curl || {
                error "brew install curl 执行失败"
                exit 1
            }
        }
        which jq >/dev/null 2>&1 || {
            log "准备安装jq命令..."
            brew install jq || {
                error "brew install jq 执行失败"
                exit 1
            }
        }
        return
        ;;
    Linux)
        # Centos 基本命令检测
        test -r /etc/redhat-release && grep "CentOS" /etc/redhat-release >/dev/null 2>&1 && {

            which curl >/dev/null 2>&1 || {
                log "准备安装curl命令"
                sudo yum -y install curl || {
                    error "sudo yum -y install curl 执行失败"
                    exit 1
                }
            }
            which jq >/dev/null 2>&1 || {
                log "准备安装jq命令..."
                sudo yum -y install jq || {
                    error "sudo yum -y install jq 执行失败"
                    exit 1
                }
            }
            return
        }
        # Ubuntu 基本命令检测
        lsb_release -a 2>/dev/null | grep "Ubuntu" >/dev/null 2>&1 && {
            which curl >/dev/null 2>&1 || {
                log "准备安装curl命令"
                sudo apt -y install curl || {
                    error "sudo apt -y install curl 执行失败"
                    exit 1
                }
            }
            which jq >/dev/null 2>&1 || {
                log "准备安装jq命令..."
                sudo apt -y install jq || {
                    error "sudo apt -y install jq 执行失败"
                    exit 1
                }
            }
            return
        }
        ;;

    esac
}
function getName() {
    curl_name=$(curl -s 'http://cqlgcj.sccchina.net/student/student/intellstudy/getlogindetail' -H "${header_accept}" -H "${header_accept_language}" -H "${header_content_type}" -H "${header_cookie}" "${header_Origin}" -H "${header_user_agent}" -H "${header_x_Requested_with}" -H "${header_metadataCode}" --data '{"data":"aggregation"}')
    test "${curl_name}" = "RedirectToLogin" && {
        echo "cookie已失效"
        exit 1
    }
    name=$(echo "$curl_name" | jq '.data.realName' | tr -d "\"")
    echo "姓名:${name}"

set +x
}

function main() {
    for (( ; ; )); do
        finished=0

        # 获取课程进度
        curl_courst_list=$(curl -s 'http://cqlgcj.sccchina.net/student/student/coursestudy/getlist' -H "${header_accept}" -H "${header_accept_language}" -H "${header_content_type}" -H "${header_cookie}" "${header_Origin}" -H "${header_user_agent}" -H "${header_x_Requested_with}" -H "${header_metadataCode}" --data '{"data":"aggregation"}')

        # 如果cookie失效
        test "${curl_courst_list}" = "RedirectToLogin" && {
            echo "cookie已失效"
            exit 1
        }

        courst_list_length=$(echo "$curl_courst_list" | jq '.items | length')
        for ((i = 0; i < courst_list_length; i++)); do
            course_name=$(echo "$curl_courst_list" | jq -r ".items[$i].courseName")
            course_id=$(echo "$curl_courst_list" | jq -r ".items[$i].courseVersionID")
            course_progress=$(echo "$curl_courst_list" | jq ".items[$i].realCoursewarePlayTime" | tr -d " " | tr -d "\"")
            course_progress_current=$(echo "$course_progress" | cut -d "/" -f1)

            course_progress_current_compare=$(echo "$course_progress_current" | cut -d "." -f1)

            # 对比方式:状态
            course_progress_status=$(echo "$curl_courst_list" | jq ".items[$i].status")
            test "${course_progress_status}" -eq 2 && {
                echo "课程:${course_name} 已结束"
                finished=$((finished + 1))
                continue
            }

            course_progress_total=$(echo "$course_progress" | cut -d "/" -f2)

            # 对比方式:观看时间和总时间
            test "${course_progress_current_compare}" -ge "${course_progress_total}" && {
                echo "课程:${course_name} 已完成"
                finished=$((finished + 1))
                continue
            }

            echo "课程:${course_name} 进度:${course_progress_current}/${course_progress_total}"

            # 保存学习进度
            curl_adddurationpc=$(curl -s 'http://cqlgcj.sccchina.net/student/student/coursestudyrecord/adddurationpc' -H "${header_accept}" -H "${header_accept_language}" -H "${header_content_type}" -H "${header_cookie}" -H "${header_Origin}" -H "${header_Referer}" -H "${header_user_agent}" -H "${header_x_Requested_with}" -H "${header_studentversion_video}" --data "{\"data\":{\"courseVersionId\":\"${course_id}\",\"studyDuration\":${studyDuration}}}")

            # 错误判断
            errcode=$(echo "$curl_adddurationpc" | jq '.errorCode')
            test "${errcode}" != "0" && {
                echo "执行错误"
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

init
getName
main
