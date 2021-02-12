println("hello world")

function sphere_vol(r)
    return 4/3*pi*r^3
end  

quadratic(a,sqr_term,b) = (-b+sqr_term)/2a #2a == 2*a


function quadratic2(a::Float64, b::Float64, c::Float64)

    sqr_term = sqrt(Complex(b^2-4a*c))
    r1 = quadratic(a,sqr_term,b)
    r2 = quadratic(a,-sqr_term,b)

    return r1,r2 #if no return then last term is returned

end 



