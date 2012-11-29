#-*- coding: utf-8 -*-

import os
from fnmatch import fnmatch
import re
import subprocess

class Compc:
    flex_home = None
    external_library_paths = None
    library_paths = None
    source_paths = None
    output_path = None
    
    def swc_filter(self, filename):
        return any(filename.endswith(e) for e in [".swc"])
    
    def parse_library_path(self, path_string):
        path = os.path.join(path_string)
        paths = []
        
        for file in os.listdir(path):
            if self.swc_filter(file):
                paths.append(os.path.join(path, file))
                
        return paths
    
    def class_filter(self, filename):
        if re.search("__Example", filename):
            return None
        
        return any(filename.endswith(e) for e in [".as", ".mxml"])
    
    def parse_include_classes(self, path_string):
        path = os.path.join(path_string)
        classes = []
        
        for parent, directories, files in os.walk(path):
            for file in filter(self.class_filter, files):
                classes.append(parent + "\\" + os.path.splitext(file)[0])
                
        return classes
    
    def build(self):
        args = []
        
        # external-library-path 만들기
        
        external_library_path_strings = []
        
        for path_string in self.external_library_paths:
            external_library_path_strings.extend(self.parse_library_path(path_string))
            
        args.append('-external-library-path ' + ' -external-library-path '.join(external_library_path_strings))
        
        
        # library-path 만들기
        
        library_path_strings = []
        
        for path_string in self.library_paths:
            library_path_strings.extend(self.parse_library_path(path_string))
            
        args.append('-library-path ' + ' -library-path '.join(library_path_strings))
        
        
        # source-path 만들기
        
        source_path_strings = []
        
        for path_string in self.source_paths:
            source_path_strings.append(path_string)
            
        args.append('-source-path ' + ' -source-path '.join(source_path_strings))
        
        # include-classes 만들기
        
        include_class_strings = []
        
        for path_string in self.source_paths:
            classes = self.parse_include_classes(path_string)
            
            for cls in classes:
                include_class_strings.append(cls[len(path_string):len(cls)].replace("\\", "."))
                
        args.append('-output ' + self.output_path)
            
        args.append('-include-classes ' + ' '.join(include_class_strings))
            
        compc = os.path.join(self.flex_home, 'bin', 'compc')
        
        cmd = compc + " " + " ".join(args)
        
        fd = subprocess.Popen(cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        for line in fd.stdout.readlines():
            print line.decode("EUC-KR")
        
