src_path=$(realpath $0)
src_path=$(dirname $src_path)
source "${src_path}"/Common.sh
source "${src_path}"/CommonConfig.sh
component=dispatch

setupGolang
