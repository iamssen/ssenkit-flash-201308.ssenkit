#-*- coding: utf-8 -*-

import flash_compilers

compc = flash_compilers.Compc()

compc.flex_home = "e:\\Settings\\flex_sdk_4.8\\"
compc.external_library_paths = ["e:\\Settings\\flex_sdk_4.8\\frameworks\\libs\\player\\11.4\\", "e:\\Settings\\flex_sdk_4.8\\frameworks\\libs\\"]
compc.library_paths = ["e:\\Workspace.G\\SSenKit\\libs\\"]
compc.source_paths = ["e:\\Workspace.G\\SSenKit\\src\\"]
compc.output_path = "e:\\Workspace.G\\SSenKit\\bin\\SSenKit.Release.swc"
compc.build()

compc.flex_home = "e:\\Settings\\flex_sdk_4.8\\"
compc.external_library_paths = ["e:\\Settings\\flex_sdk_4.8\\frameworks\\libs\\air\\", "e:\\Settings\\flex_sdk_4.8\\frameworks\\libs\\"]
compc.library_paths = ["e:\\Workspace.G\\SSenKit\\libs\\", "e:\\Workspace.G\\SSenKit.Air\\libs\\"]
compc.source_paths = ["e:\\Workspace.G\\SSenKit\\src\\", "e:\\Workspace.G\\SSenKit.Air\\src\\"]
compc.output_path = "e:\\Workspace.G\\SSenKit.Air\\bin\\SSenKit.Air.Release.swc"
compc.build()