package ssen.common.ds {
import de.polygonal.ds.Itr;
import de.polygonal.ds.TreeNode;

/** @includeExample DataConverterExample.as */
public class DataConverter {
	/** 복합적인 key 를 가진 데이터 리스트를 Tree 형태로 전환한다 */
	public static function multipleKeyDatasToTree(itr:Itr, categoryKeys:Vector.<String>, root:TreeNode=null, appendLastNodeWith:Function=null):TreeNode {
		if (root === null) {
			root=new TreeNode;
		}
		
		var node:TreeNode;
		var source:Object;
		var key:String;
		
		var f:int;
		var fmax:int;
		
		while (itr.hasNext()) {
			source=itr.next();
			
			f=-1;
			fmax=categoryKeys.length;
			node=root;
			
			while (++f < fmax) {
				key=source[categoryKeys[f]];
				
				if (node.find(key) === null) {
					node.appendNode(new TreeNode(key));
				}
				
				node=node.find(key) as TreeNode;
				
				if (f === fmax - 1) {
					if (appendLastNodeWith === null) {
						node.appendNode(new TreeNode(source));
					} else {
						appendLastNodeWith(node, source);
					}
				}
			}
		}
		
		return root;
	}
}
}
