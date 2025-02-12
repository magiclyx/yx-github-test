#!/usr/bin/env bash


source yxlibinit "/Users/emanon/Desktop/repo/yxlib/yxlib/yxlib/bin"
source "${YXLIB_BIN}/yxnet" 


function github_host_list()
{
  cat <<EOF
140.82.112.26               alive.github.com
140.82.112.25               live.github.com
185.199.108.154             github.githubassets.com
140.82.114.22               central.github.com
185.199.109.133             desktop.githubusercontent.com
185.199.110.153             assets-cdn.github.com
185.199.110.133             camo.githubusercontent.com
185.199.109.133             github.map.fastly.net
151.101.77.194              github.global.ssl.fastly.net
20.205.243.166              gist.github.com
185.199.109.153             github.io
20.205.243.166              github.com
192.0.66.2                  github.blog
20.205.243.168              api.github.com
185.199.110.133             raw.githubusercontent.com
185.199.111.133             user-images.githubusercontent.com
185.199.110.133             favicons.githubusercontent.com
185.199.108.133             avatars5.githubusercontent.com
185.199.108.133             avatars4.githubusercontent.com
185.199.110.133             avatars3.githubusercontent.com
185.199.109.133             avatars2.githubusercontent.com
185.199.108.133             avatars1.githubusercontent.com
185.199.108.133             avatars0.githubusercontent.com
185.199.111.133             avatars.githubusercontent.com
20.205.243.165              codeload.github.com
3.5.25.37                   github-cloud.s3.amazonaws.com
52.216.39.9                 github-com.s3.amazonaws.com
54.231.203.81               github-production-release-asset-2e65be.s3.amazonaws.com
52.216.39.17                github-production-user-asset-6210df.s3.amazonaws.com
52.216.213.241              github-production-repository-file-5c1aeb.s3.amazonaws.com
185.199.108.153             githubstatus.com
140.82.113.18               github.community
20.43.185.14                github.dev
140.82.114.22               collector.github.com
13.107.42.16                pipelines.actions.githubusercontent.com
185.199.109.133             media.githubusercontent.com
185.199.111.133             cloud.githubusercontent.com
185.199.110.133             objects.githubusercontent.com
EOF
}

#function github_host_list()
#{
# cat <<EOF
#151.101.77.194              github.global.ssl.fastly.net
#EOF
#}


IFS_STORAGE="${IFS}"
IFS=$'\n'
for line in $(github_host_list); do
  ip=$(echo "${line}" | awk '{print $1}')
  host=$(echo "${line}" | awk '{print $2}')
  
  printf "%-60s" "${host} ..."
  if err_msg=$(yx_test_host --host "${host}" --no-ping --proto https 2>&1 >/dev/null); then
    echo -ne "\033[1G\033[K"
    printf "%-60s %s\n" ${host} ":OK"
  else
    
    # remove all '\n' with a white space but escape the last one.
    err_msg=$(echo -e "${err_msg}" | tr '\n' ' ' | sed '$s/ $/\n/' )
    
    echo -ne "\033[1G\033[K"
    if [ -n "${err_msg}" ]; then
      printf "%-60s %s (%s)\n" ${host} ":Failed" "${err_msg}"
    else
      printf "%-60s %s\n" ${host} ":Failed"
    fi
  fi
  
done
IFS="${IFS_STORAGE}"

