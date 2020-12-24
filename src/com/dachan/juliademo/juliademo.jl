#=
juliademo:
- Julia version: 1.5.3
- Author: kenychen
- Date: 2020-12-23
=#
using Test;

function calculator(x, y, operation)
    if operation == "+"
        x + y
    elseif operation == "-"
        x - y
    elseif operation == "*"
        x*y
    elseif operation == "/"
        x / y
    else
        println("Incorrect operation")
        return 0
    end
end

testcalculator=calculator(100,5,"/")
println("testcalculator 100/5=:$testcalculator");

@testset "calculator Tests 1+1=2,1-1=0,2*2=4,10/2=5.0" begin
           @test calculator(1,1,"+")   == 2
           @test calculator(1,1,"-")  == 0
           @test calculator(2,2,"*") == 4
           @test calculator(10,2,"/") == 5.0
           end;






