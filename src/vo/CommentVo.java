package vo;

import entity.Comment;

import java.util.Date;


public class CommentVo extends Comment {
	private Date begin_date;
	private Date end_date;
	private Integer pageNo;
	private String login_name;
	private String nickname;
	private Integer praise_count;
	private Integer chapter_id;
	private Integer status;
	
	
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Integer getPraise_count() {
		return praise_count;
	}
	public void setPraise_count(Integer praise_count) {
		this.praise_count = praise_count;
	}
	public Date getBegin_date() {
		return begin_date;
	}
	public void setBegin_date(Date begin_date) {
		this.begin_date = begin_date;
	}
	public Date getEnd_date() {
		return end_date;
	}
	public void setEnd_date(Date end_date) {
		this.end_date = end_date;
	}
	public Integer getPageNo() {
		return pageNo;
	}
	public void setPageNo(Integer pageNo) {
		this.pageNo = pageNo;
	}
	public String getLogin_name() {
		return login_name;
	}
	public void setLogin_name(String login_name) {
		this.login_name = login_name;
	}
	@Override
	public String toString() {
		return "CommentVo [begin_date=" + begin_date + ", end_date=" + end_date
				+ ", pageNo=" + pageNo + ", login_name=" + login_name
				+ ", praise_count=" + praise_count +",status="+status;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public Integer getChapter_id() {
		return chapter_id;
	}
	public void setChapter_id(Integer chapter_id) {
		this.chapter_id = chapter_id;
	}
	
}
