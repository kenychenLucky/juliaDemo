#=
redisdemo:
- Julia version: 1.5.3
- Author: dev
- Date: 2020-12-24
=#
using Redis
conn = RedisConnection()

 scan(conn,0,"match","k*")
julia> scan(conn,2,:count,2)
(3, AbstractString["demo", "key"])
​
julia> pipeline = open_pipeline(conn)
Redis.PipelineConnection("127.0.0.1", 6379, "", 0, Sockets.TCPSocket(Base.Libc.WindowsRawSocket(0x0000000000002368) open, 0 bytes waiting), 0)
​
julia> set(pipeline,"somekey","somevalue")
1
​
julia> response= read_pipeline(pipeline)
1-element Array{Any,1}:
 "OK"
​
julia> multi(conn)
true
​
julia> set(conn,"key","kenychenabc")
true
​
julia> get(conn,"key")
"QUEUED"
julia> exec(conn)
​
julia> get(conn,"key")
"kenychenabc"