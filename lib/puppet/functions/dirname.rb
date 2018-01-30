Puppet::Functions.create_function(:dirname) do
    dispatch :dirname do
        param 'String', :path
    end

    def dirname(path)
        File.dirname(path)
    end
end
