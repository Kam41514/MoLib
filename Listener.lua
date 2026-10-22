local oldNamecall

oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()

    if method == "FireServer" or method == "InvokeServer" then
        if typeof(self) == "Instance"
            and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then

            local args = {...}

            print("========== REMOTE ==========")

            print("Remote:", self.Name)

            -- Method
            print("Method:", method)

            -- Arguments
            for i, value in ipairs(args) do
                print(("Arg[%d]:"):format(i), value)
            end

            print("============================")
        end
    end

    return oldNamecall(self, ...)
end))
