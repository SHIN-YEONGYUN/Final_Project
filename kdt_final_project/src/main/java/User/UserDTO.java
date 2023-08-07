package User;

import org.springframework.stereotype.Component;

@Component
public class UserDTO {
	int id;
	String nickname, username,userpw,userid;
	String phone, email, mbti,grade;
	String postcode,address,detailAddress,extraAddress;
	String photo;

	public UserDTO() {
	}

	public UserDTO(int id, String nickname, String username, String userpw, String userid, String phone, String email,
			String mbti, String grade, String postcode, String address, String detailAddress, String extraAddress,
			String photo) {
		super();
		this.id = id;
		this.nickname = nickname;
		this.username = username;
		this.userpw = userpw;
		this.userid = userid;
		this.phone = phone;
		this.email = email;
		this.mbti = mbti;
		this.grade = grade;
		this.postcode = postcode;
		this.address = address;
		this.detailAddress = detailAddress;
		this.extraAddress = extraAddress;
		this.photo = photo;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getUserpw() {
		return userpw;
	}

	public void setUserpw(String userpw) {
		this.userpw = userpw;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getMbti() {
		return mbti;
	}

	public void setMbti(String mbti) {
		this.mbti = mbti;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getPostcode() {
		return postcode;
	}

	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getDetailAddress() {
		return detailAddress;
	}

	public void setDetailAddress(String detailAddress) {
		this.detailAddress = detailAddress;
	}

	public String getExtraAddress() {
		return extraAddress;
	}

	public void setExtraAddress(String extraAddress) {
		this.extraAddress = extraAddress;
	}

	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

	
	@Override
	public String toString() {
		return "UserDTO [id=" + id + ", nickname=" + nickname + ", username=" + username + ", userpw=" + userpw
				+ ", userid=" + userid + ", phone=" + phone + ", email=" + email + ", mbti=" + mbti + ", grade=" + grade
				+ ", postcode=" + postcode + ", address=" + address + ", detailAddress=" + detailAddress
				+ ", extraAddress=" + extraAddress + ", photo=" + photo + "]";
	}




}
