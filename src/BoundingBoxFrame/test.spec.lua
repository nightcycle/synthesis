return function ()
	describe("BoundingBoxFrame", function()
		it("should boot", function()
			local Checkbox = require(script.Parent)
			expect(Checkbox).to.be.ok()
		end)
		it("should construct", function()
			local Checkbox = require(script.Parent)
			local checkbox = Checkbox.new({})
			expect(checkbox).never.to.equal(nil)
			checkbox:Destroy()
		end)
	end)
end