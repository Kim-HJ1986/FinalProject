package www.dream.com.party.model;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 사장. 운영자 등록, 삭제 권한 있음
 * @author ivarBae
 */
@Data
@NoArgsConstructor
public class Admin extends Party {@Override
	
	public String toString() {
		return "Admin [toString()=" + super.toString() + "]";
	}

	public Admin(String userId) {
		super(userId);
	}
	
}
