--!strict
--!native
-- https://github.com/material-foundation/material-color-utilities/blob/f5d03da60c268b43928f3a24d6bf499e2564d39a/typescript/utils/math_utils.ts

local Util = {}

function Util.signum(num: number): number
	if num < 0 then
		return -1
	elseif num == 0 then
		return 0
	else
		return 1
	end
end

function Util.lerp(start: number, stop: number, amount: number): number
	return (1.0 - amount) * start + amount * stop
end

function Util.clampInt(min: number, max: number, input: number): number
	if input < min then
		return min
	elseif input > max then
		return max
	end

	return input
end

function Util.clampDouble(min: number, max: number, input: number): number
	if input < min then
		return min
	elseif input > max then
		return max
	end

	return input
end

function Util.sanitizeDegreesInt(degrees: number): number
	degrees = degrees % 360
	if degrees < 0 then
		degrees = degrees + 360
	end
	return degrees
end

function Util.sanitizeDegreesDouble(degrees: number): number
	degrees = degrees % 360.0
	if degrees < 0 then
		degrees = degrees + 360.0
	end
	return degrees
end

function Util.rotationDirection(from: number, to: number): number
	local increasingDifference = Util.sanitizeDegreesDouble(to - from)
	return if increasingDifference <= 180.0 then 1.0 else -1.0
end

function Util.differenceDegrees(a: number, b: number): number
	return 180.0 - math.abs(math.abs(a - b) - 180.0)
end

function Util.matrixMultiply(row: { number }, matrix: { { number } }): { number }
	local a = row[0] * matrix[0][0] + row[1] * matrix[0][1] + row[2] * matrix[0][2]
	local b = row[0] * matrix[1][0] + row[1] * matrix[1][1] + row[2] * matrix[1][2]
	local c = row[0] * matrix[2][0] + row[1] * matrix[2][1] + row[2] * matrix[2][2]
	return {
		[0] = a,
		[1] = b,
		[2] = c,
	}
end

return Util
