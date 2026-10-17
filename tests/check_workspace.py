"""Offline scaffolding checks; never install software or launch user apps."""
import json,os,subprocess,sys,tempfile,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
class WorkspaceCheck(unittest.TestCase):
    def test_scaffold_and_preserve(self):
        scratch=ROOT/'.qa';scratch.mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(prefix='test space ',dir=scratch) as d:
            target=Path(d)/'我的项目 with spaces'
            if sys.platform=='darwin':cmd=['bash',str(ROOT/'scripts/setup-macos.sh'),'--workspace',str(target)]
            elif sys.platform=='win32':cmd=['pwsh','-NoProfile','-File',str(ROOT/'scripts/setup-windows.ps1'),'-Workspace',str(target)]
            else:self.skipTest('Only macOS/Windows scaffold supported')
            subprocess.run(cmd,check=True,capture_output=True,text=True)
            for name in ['00_选题与研究主线','01_模拟与实验','02_分析与制图','03_结果','04_稿件','05_投稿']:self.assertTrue((target/name).is_dir(),name)
            for source in (ROOT/'templates/workspace').rglob('*'):
                if source.is_file():self.assertEqual(source.read_bytes(),(target/source.relative_to(ROOT/'templates/workspace')).read_bytes())
            config=json.loads((target/'我的项目.code-workspace').read_text(encoding='utf-8'))
            self.assertEqual(config['folders'][0]['path'],'.')
            note=target/'项目进度.md';note.write_text('用户已改动，请保留',encoding='utf-8')
            subprocess.run(cmd,check=True,capture_output=True,text=True)
            self.assertEqual(note.read_text(encoding='utf-8'),'用户已改动，请保留')
    def test_public_paths_and_template_links(self):
        allowed={'.md','.json','.sh','.ps1','.py','.tex','.csv','.html','.yml'}
        for p in ROOT.rglob('*'):
            if any(x.startswith('.') for x in p.relative_to(ROOT).parts):continue
            if p.is_file() and p.suffix in allowed:
                text=p.read_text(encoding='utf-8-sig')
                self.assertNotIn('/Users/'+'qz/',text,str(p))
                self.assertNotIn('LNP '+'Ligand Presentation',text,str(p))
        self.assertEqual((ROOT/'example/index.html').read_bytes(),(ROOT/'templates/workspace/03_结果/示例_一周待办.html').read_bytes())
if __name__=='__main__':unittest.main(verbosity=2)
