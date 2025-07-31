#!/bin/bash
#
# deploylib.sh - Ansible deploy data loader
# 使用说明：
# 1. 在Git仓库根目录下创建".deployenv"文件，通过key=value的形式配置环境变量，一行一个配置，一个分支一组
# [master]
# deploy_version=1.0.1
# composer_install=true
# restart_service=true
# 2. 编辑post-receive钩子
# # 引入函数库
# source /data/deploylib.sh
# # 解析 .deployenv 文件内部并转为json数据：{"deploy":{...}}
# DEPLOY_DATA=$(get_deploy_data_from_repo "$branch")
# 3. 使用json数据，传给ansible剧本，根据指定配置，灵活设置CI/CD流程
# ansiblesh ansible-playbook example.yaml -e '$DEPLOY_DATA' -e 'branch=$branch'

# 解析 .deployenv 文件内容 key=value 为 JSON 字符串
extract_deploy_vars() {
    local repo_dir="${1:-.}"
    local deploy_file="$repo_dir/.deployenv"
    local temp_line key value result=""
    local current_section=""
    local target_section="${2:-master}"  # 传入当前 branch，如 master
    local first=1

    # 检查文件是否存在
    if [ ! -f "$deploy_file" ]; then
        echo "" # 返回空，表示文件不存在
        return 1
    fi

    # 逐行读取，避免一次性加载大文件
    while IFS= read -r temp_line || [ -n "$temp_line" ]; do
        # 去除首尾空白
        temp_line=$(echo "$temp_line" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

        # 跳过空行和注释
        case "$temp_line" in
            ""|"#"*)
                continue
                ;;
        esac

        # 匹配 [branch] section
        case "$temp_line" in 
            \[*\])  
                current_section="${temp_line#[}"
                current_section="${current_section%]}"
                current_section=$(echo "$current_section" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
                continue
                ;;
        esac

        # 必须包含 =
        case "$temp_line" in
            *"="*)
                ;;
            *)
                continue
                ;;
        esac

        # 分割 key/value
        key="${temp_line%%=*}"
        value="${temp_line#*=}"

        # 去除首尾空白
        key=$(echo "$key" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
        value=$(echo "$value" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

        # 跳过空 key
        if [ -z "$key" ]; then
            continue
        fi

        # 去除外层双引号（如果存在）
        if [ "${value#\"}" != "$value" ] && [ "${value%\"}" != "$value" ]; then
            value="${value#\"}"
            value="${value%\"}"
        fi

        # 只处理目标 branch 的 section
        if [[ "$current_section" == "$target_section" ]]; then
            if [ $first -eq 1 ]; then
                result="\"$key\":\"$value\""
                first=0
            else
                result="$result,\"$key\":\"$value\""
            fi
        fi

    done < "$deploy_file"

    # 输出结果
    if [ -n "$result" ]; then
        echo "{\"deploy\":{$result}}"
    else
        echo "{}"
    fi
}

# 获取 .deployenv 数据，repo_dir 仓库地址作为参数传入
get_deploy_data() {
    local repo_dir="${1:-.}"
    local branch="${2:-master}" 
    local deploy_data

    if [[ -z "$repo_dir" ]]; then
        echo '{"deploy":{}}'
        return 1
    fi

    # 传入 branch 名，只提取该 branch 的配置
    deploy_data=$(extract_deploy_vars "$repo_dir" "$branch")

    if [[ $? -ne 0 || -z "$deploy_data" ]]; then
        echo '{"deploy":{}}'
        return 1
    fi

    echo "$deploy_data"
}

# 获取仓库 .deployenv 文件并复制到临时文件，再从临时文件解析数据
get_deploy_data_from_repo() {
    local branch="${1:-master}"  # 默认 HEAD，可传入 develop, main 等
    local tmp_deploy
    local tmp_dir
    local deploy_data='{"deploy":{}}'  # 默认空对象

    # 安全生成临时文件和目录
    tmp_deploy=$(mktemp -t deployenv.XXXXXX) || {
        echo "Failed to create temp file" >&2
        echo "$deploy_data"
        return 1
    }
    tmp_dir=$(mktemp -d -t deploydata.XXXXXX) || {
        echo "Failed to create temp directory" >&2
        rm -f "$tmp_deploy"
        echo "$deploy_data"
        return 1
    }
    # 确保退出时清理（即使出错）
    trap 'rm -rf "$tmp_dir" "$tmp_deploy" 2>/dev/null || true' EXIT

    # 从 Git 仓库提取 .deployenv 文件
    if git show "${branch}:.deployenv" > "$tmp_deploy" 2>/dev/null; then
        cp "$tmp_deploy" "$tmp_dir/.deployenv"
        # 解析数据
        deploy_data=$(get_deploy_data "$tmp_dir" "$branch")
        ret=$?

        [[ $ret -ne 0 ]] && deploy_data='{"deploy":{}}'
    else
        # 文件不存在，返回默认值
        :
    fi

    # 输出最终结果
    echo "$deploy_data"
}

