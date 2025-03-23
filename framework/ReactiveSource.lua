--========================================================--
--                Reactive Source File                                          --
--                                                        --
-- Author      :  kurapica125@outlook.com                 --
-- Create Date :  2025/03/21                              --
--========================================================--

--========================================================--
Scorpio           "Scorpion"                              ""
--========================================================--

__Sealed__() __FileType__()
class "ReactiveSourceFile"              (function(_ENV)
    inherit "File" extend "IReactiveSource"

    __Sealed__()
    struct "ReactiveDefine"             (function(_ENV)
        Sources                         = struct { IReactiveSource }
        
    end)

    -------------------------------------------------------
    --                      Method                       --
    -------------------------------------------------------
    --- Save the file to content
    function Dump(self)
        
    end

    --- Load the file from content
    function Load(self, content)
        
    end

    --- Get the reactive source
    function GetReactiveSource(self)
        
    end
end)