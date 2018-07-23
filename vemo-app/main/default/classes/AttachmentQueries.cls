public class AttachmentQueries {
	public static Map<ID, Attachment> getAttachmentMap(){
		return new Map<ID, Attachment>([SELECT id,
											Body,
											ContentType,
											Name, 
											ParentId
										FROM Attachment
										LIMIT 50000]);
	}

	public static Map<ID, Attachment> getAttachmentMapWithAttachmentID(Set<ID> attachmentIDs){
		return new Map<ID, Attachment>([SELECT id,
											Body,
											ContentType,
											Name, 
											ParentId
										FROM Attachment
										WHERE ID IN: attachmentIDs
										LIMIT 50000]);
	}

	public static Map<ID, Attachment> getAttachmentMapWithParentID(Set<ID> parentIDs){
		return new Map<ID, Attachment>([SELECT id,
											Body,
											ContentType,
											Name, 
											ParentId
										FROM Attachment
										WHERE ParentId IN: parentIDs
										LIMIT 50000]);
	}
}