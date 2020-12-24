#=
getbaidu:
- Julia version: 1.5.3
- Author: dev
- Date: 2020-12-23
=#
#=
juliademo:
- Julia version: 1.5.3
- Author: kenychen
- Date: 2020-12-23
=#
using Pkg
Pkg.add("HTTP")
Pkg.add("JSON")

using HTTP;
using JSON;

const url = "http://www.baidu.com/s?wd="
const kw = "电影"
strs = "#我是中国人"

function get_kw_test()
     temp = string(url,"",kw)
     r = HTTP.get(temp)
     return String(r.body);

end
html = get_kw_test();
println("get html :$html");




