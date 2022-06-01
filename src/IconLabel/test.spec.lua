return function ()
	describe("Checkbox", function()
		it("should boot", function()
			local Icon = require(script.Parent)
			expect(Icon).to.be.ok()
		end)
		it("should construct", function()
			local Icon = require(script.Parent)
			local icon = Icon.new({})
			expect(icon).never.to.equal(nil)
			icon:Destroy()
		end)
	end)
end