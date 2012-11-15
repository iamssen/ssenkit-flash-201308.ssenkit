package ssen.datakit.file {


public class FileUtils {
	public static function addExtensionToFileName(fileName:String, extension:String):String {
		var names:Array=fileName.split(".");

		if (names.length !== 1 && names[names.length - 1] == extension) {
			return fileName;
		}

		return fileName + "." + extension;
	}

	public static function removeExtension(fileName:String):String {
		var names:Array=fileName.split(".");

		if (names.length > 1) {
			names.pop();
			return names.join(".");
		}

		return fileName;
	}
}
}
