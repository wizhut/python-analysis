import requests
import re
import tarfile
import subprocess

from html.parser import HTMLParser

PYTHON_LIST_HTML = 'https://www.python.org/ftp/python'

def load_html(url):
    r = requests.get(url)
    return r.text

def download_file(url, to_file=None):
    r = requests.get(url)
    
    if to_file is None:
        return 0
    else:
        fp = open(to_file, 'wb')
        fp.write(r.content)
        fp.close()
        return len(r.content)

class PythonVersionHTMLParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.__versions = []
    
    def handle_data(self, data):
        m = re.match('3\\.[0-9]{1,2}\\.[0-9]{1,2}', data)
        
        if m is not None:
            self.__versions.append(m.group(0))
        
    def versions(self):        
        return self.__versions
    
    
class PythonTarballHTMLParser(HTMLParser):
    def __init__(self, prefix, url):
        super().__init__()
        self.__prefix = prefix
        self.__url = url
        self.__filename = None
        self.__tarball_url = None
        
    def handle_data(self, data):
        m = re.match(f'Python-{self.__prefix}\\.((tar\\.gz)|(tar\\.(bz2))|(tgz))', data)
        
        if m is not None and self.__filename is None:
            self.__tarball_url = f'{self.__url}/{m.group(0)}'
            self.__filename = m.group(0)
    
    def filename(self):
        return self.__filename
    
    def tarball_url(self):
        return self.__tarball_url
    
    def prefix(self):
        return self.__prefix
    
    def directory_name(self):
        return f'Python-{self.__prefix}'
        
        
parser = PythonVersionHTMLParser()
parser.feed(load_html(PYTHON_LIST_HTML))

for v in parser.versions():
    url = f'{PYTHON_LIST_HTML}/{v}'
    p = PythonTarballHTMLParser(v, url)
    p.feed(load_html(url)) 

    if p.filename() is not None:
        local_path = f'work/{p.filename()}'
        size_t = download_file(p.tarball_url(), to_file=local_path)
        print(f'processing ... {p.tarball_url()} => {p.filename()}, {size_t} bytes (prefix={p.directory_name()})')
        
        if local_path.endswith(('gz', 'bz2')):
            tr = tarfile.open(local_path)
            tr.extractall('./work')
            subprocess.run(['uv', 'run', 'ruff', 'check', local_path, '-- --format=json --output-file='])
        else:
            print(f'do now know how to extract .... {local_path}')
        
