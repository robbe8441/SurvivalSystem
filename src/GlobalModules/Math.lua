local module = {}

function module.lerp(a, b, t)
    return a + (b - a) * t
end

function module.CubicBezier(p1,p2, p3,t)
    local l1 = module.lerp(p1, p2, t)
    local l2 = module.lerp(p2, p3, t)
    return module.lerp(l1, l2, t)
end

function module.SmoothMin(a, b, k)  -- k negative = Smooth Max
    local h = math.clamp((b - a + k) / (2 *k), 0,1);
    return a * h + b * (1 - h) - k * h * (1 - h);
end

function Bias(x, bias)
    local k = (1-bias) ^ 3
    return (x * k) / (x * k - x + 1);
end

function module.map(value, inMin, inMax, outMin, outMax)
    return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin)
end


function module.average(...)
    local tab = {...}
    local v = 0
    for i=1,#tab do
        v += tab[i]
    end
    return v / #tab
end



return module
