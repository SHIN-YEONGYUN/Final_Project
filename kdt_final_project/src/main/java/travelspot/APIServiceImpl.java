package travelspot;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

@Service("apiservice")
@Transactional
public class APIServiceImpl {

	
	String serviceKey = "A7Izc9O8PXKHKY%2FsWnQUYwt5u6dujTuf3unurHLSOEIfHLv%2F7waxlcZgPnRqpsKUO60J64lzoZ%2FYO3wW5sH1rw%3D%3D";

	StringBuilder urlBuilder;

	@Autowired
	PlaceMapper placemapper;

	public String getBasicData() throws Exception {
		// 기본 관광지
		int[] areaCodes = {32,6,2,5,7,31};
		for(int i=0; i<areaCodes.length; i++) {
			getBasicInfo(areaCodes[i]);
		}
		// 테마별관광지
		getThemeBasicInfo();
		
		return "ok";
	}
	
	//@Scheduled(cron = "0 28 16 * * *")
	public void ScheduledTasksMethod() throws Exception { // place2, contents2 테이블에 데이터 저장 -> place, contents 테이블에 붙여넣기

		// System.out.println("확인");

		// 기본 관광지
		int[] areaCodes = { 32, 6, 2, 5, 7, 31 };
		for (int i = 0; i < areaCodes.length; i++) {
			getBasicInfo2(areaCodes[i]);
		}

		// 테마별관광지
		getThemeBasicInfo2();

		// place2 테이블의 모든 데이터 -> 리스트로 가져오기 -> for문 돌면서 place 테이블 정보 변경
		List<PlaceDTO> placelist = placemapper.selectAllPlace();

		for (PlaceDTO one : placelist) {
			placemapper.copyTablePlace2(one);
		}

		// contents2 테이블의 모든 데이터 -> 리스트로 가져오기 -> for문 돌면서 contents 테이블 정보 변경
		List<ContentsDTO> contentlist = placemapper.selectAllContents();

		for (ContentsDTO one : contentlist) {
			System.out.println(one.toString());
			int result = placemapper.copyThemeDetail(one);
			System.out.println("변화된 행의 갯수: " + result);
		}

	}

	// 전체 관광지 추천용: 테마 없는 기본 장소 불러오기(지역코드 이용)
	public void getBasicInfo(int areaCode) throws Exception {

		urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/areaBasedList1");

		urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + serviceKey);
		urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("100", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("test", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("arrange", "UTF-8") + "=" + URLEncoder.encode("O", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("areaCode", "UTF-8") + "="
				+ URLEncoder.encode(String.valueOf(areaCode), "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("contentTypeId", "UTF-8") + "=" + URLEncoder.encode("12", "UTF-8"));
		url(urlBuilder);

		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(String.valueOf(urlBuilder));

		NodeList nList = doc.getElementsByTagName("item");

		for (int temp = 0; temp < nList.getLength(); temp++) {
			Node nNode = nList.item(temp);

			if (nNode.getNodeType() == Node.ELEMENT_NODE) {
				Element eElement = (Element) nNode;

				Integer contentId = Integer.valueOf(getValue("contentid", eElement));
				System.out.println("contentId: " + contentId);

				String title = getValue("title", eElement);
				int areaCode1 = Integer.valueOf(getValue("areacode", eElement));
				String image1 = getValue("firstimage", eElement);
				String address = getValue("addr1", eElement);
				double mapx = Double.valueOf(getValue("mapx", eElement));
				double mapy = Double.valueOf(getValue("mapy", eElement));

				PlaceDTO placeDTO = new PlaceDTO(contentId, title, areaCode1, image1, address, mapx, mapy);
				System.out.println("place테이블 contentId" + placemapper.selectPlaceId(contentId));

				if (!StringUtils.hasText(placemapper.selectPlaceId(contentId))) {
					placemapper.insertPlaces(placeDTO);
					System.out.println("place테이블에 insert 완료:"+placeDTO.toString());
				} else {
					placemapper.updateThemePlace(placeDTO);
					System.out.println("place테이블에 update 완료"+placeDTO.toString());
				}
				// 원본테이블: placemapper.insertPlaces(placeDTO);
			} // if
		} // for
	}// test method

	// 전체 관광지 추천용2: 테마 없는 기본 장소 불러오기(지역코드 이용)
	public void getBasicInfo2(int areaCode) throws Exception {

		urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/areaBasedList1");

		urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + serviceKey);
		urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("1000", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("test", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("arrange", "UTF-8") + "=" + URLEncoder.encode("O", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("areaCode", "UTF-8") + "="
				+ URLEncoder.encode(String.valueOf(areaCode), "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("contentTypeId", "UTF-8") + "=" + URLEncoder.encode("12", "UTF-8"));
		url(urlBuilder);

		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(String.valueOf(urlBuilder));

		NodeList nList = doc.getElementsByTagName("item");

		for (int temp = 0; temp < nList.getLength(); temp++) {
			Node nNode = nList.item(temp);

			if (nNode.getNodeType() == Node.ELEMENT_NODE) {
				Element eElement = (Element) nNode;

				Integer contentId = Integer.valueOf(getValue("contentid", eElement));
				System.out.println("contentId: " + contentId);

				String title = getValue("title", eElement);
				int areaCode1 = Integer.valueOf(getValue("areacode", eElement));
				String image1 = getValue("firstimage", eElement);
				String address = getValue("addr1", eElement);
				double mapx = Double.valueOf(getValue("mapx", eElement));
				double mapy = Double.valueOf(getValue("mapy", eElement));

				PlaceDTO placeDTO = new PlaceDTO(contentId, title, areaCode1, image1, address, mapx, mapy);
				System.out.println(placeDTO.toString());
				System.out.println("place2테이블 contentId" + placemapper.selectPlaceId2(contentId));

				if (!StringUtils.hasText(placemapper.selectPlaceId2(contentId))) {
					placemapper.insertPlaces2(placeDTO);
					System.out.println("place2테이블에 insert 완료");
				} else {
					placemapper.updateThemePlace2(placeDTO);
					System.out.println("place2테이블에 update 완료");
				}
				// 원본테이블: placemapper.insertPlaces(placeDTO);
			} // if
		} // for
	}// test method

	// 캠핑(친구)
	// http://apis.data.go.kr/B551011/KorService1/areaBasedList1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey=인증키&listYN=Y&arrange=A&contentTypeId=&areaCode=&sigunguCode=&cat1=C01&cat2=C0116&cat3=C01160001
	// 힐링(연인)
	// http://apis.data.go.kr/B551011/KorService1/areaBasedList1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey=인증키&listYN=Y&arrange=A&contentTypeId=&areaCode=&sigunguCode=&cat1=C01&cat2=C0114&cat3=C01140001
	// 혼자
	// http://apis.data.go.kr/B551011/KorService1/areaBasedList1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey=인증키&listYN=Y&arrange=A&contentTypeId=&areaCode=&sigunguCode=&cat1=C01&cat2=C0113&cat3=C01130001
	// 가족
	// http://apis.data.go.kr/B551011/KorService1/areaBasedList1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey=인증키&listYN=Y&arrange=A&contentTypeId=&areaCode=&sigunguCode=&cat1=C01&cat2=C0112&cat3=C01120001

	// 테마별 게시글 contentId 불러오기2
	public void getThemeBasicInfo2() throws Exception {
		// (36)String friendUrl =
		// "http://apis.data.go.kr/B551011/KorService1/areaBasedList1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey="+serviceKey+"&listYN=Y&arrange=A&contentTypeId=&areaCode=&sigunguCode=&cat1=C01&cat2=C0116&cat3=C01160001";
		// (147) String coupleUrl =
		// "http://apis.data.go.kr/B551011/KorService1/areaBasedList1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey="+serviceKey+"&listYN=Y&arrange=A&contentTypeId=&areaCode=&sigunguCode=&cat1=C01&cat2=C0114&cat3=C01140001";
		// (54)String aloneUrl =
		// "http://apis.data.go.kr/B551011/KorService1/areaBasedList1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey="+serviceKey+"&listYN=Y&arrange=A&contentTypeId=&areaCode=&sigunguCode=&cat1=C01&cat2=C0113&cat3=C01130001";
		// (36)String familyUrl =
		// "http://apis.data.go.kr/B551011/KorService1/areaBasedList1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey="+serviceKey+"&listYN=Y&arrange=A&contentTypeId=&areaCode=&sigunguCode=&cat1=C01&cat2=C0112&cat3=C01120001";
		String serviceKey = "gyesYtRw%2BO5TYGJgK%2FiI%2FFD6htVqBdnM8lz7Qp2noL4lQCWtcnA%2BWzJ9dWkBu0dMagfS1sVHzJi3Vn8CQaqM%2Fw%3D%3D";
		String[] themeList = new String[] { "friends", "couple", "alone", "family" };
		// String[] urlList = new String[] {friendUrl, coupleUrl, aloneUrl, familyUrl };
		String[] numOfRowsList = new String[] { "20", "20", "20", "20" };
		String[] cat2List = new String[] { "C0116", "C0114", "C0113", "C0112" };
		String[] cat3List = new String[] { "C01160001", "C01140001", "C01130001", "C01120001" };

		for (int i = 0; i < themeList.length; i++) {
			urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/areaBasedList1");

			urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + serviceKey);
			urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8"));
			urlBuilder.append(
					"&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode(numOfRowsList[i], "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8"));
			urlBuilder.append(
					"&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("AppTest", "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("listYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("arrange", "UTF-8") + "=" + URLEncoder.encode("A", "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("cat1", "UTF-8") + "=" + URLEncoder.encode("C01", "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("cat2", "UTF-8") + "=" + URLEncoder.encode(cat2List[i], "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("cat3", "UTF-8") + "=" + URLEncoder.encode(cat3List[i], "UTF-8"));

			url(urlBuilder);

			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(String.valueOf(urlBuilder));

			NodeList nList = doc.getElementsByTagName("item");
			ArrayList<Integer> contentIdList = new ArrayList<Integer>();
			ArrayList<Integer> contentTypeIdList = new ArrayList<Integer>();

			for (int temp = 0; temp < nList.getLength(); temp++) {
				Node nNode = nList.item(temp);

				if (nNode.getNodeType() == Node.ELEMENT_NODE) {
					Element eElement = (Element) nNode;

					int contentId = Integer.valueOf(getValue("contentid", eElement));
					Integer contentTypeId = Integer.valueOf(getValue("contenttypeid", eElement));
					contentTypeIdList.add(contentTypeId);
					contentIdList.add(contentId);

				} // if
					// System.out.println(contentIdList.get(i));
			} // for
				// arraylist 잘 들어갔는지 확인용: System.out.println(contentIdList.size());
			System.out.println("게시글 id 저장 성공");
			getThemeInfo2(contentIdList, contentTypeIdList, themeList[i]); // 기본 정보 DB 등록 - 장소명, 테마, id

		} // url for
	}// test method

	// 테마별 게시글 contentId 불러오기
	public void getThemeBasicInfo() throws Exception {
		// (36)String friendUrl =
		// "http://apis.data.go.kr/B551011/KorService1/areaBasedList1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey="+serviceKey+"&listYN=Y&arrange=A&contentTypeId=&areaCode=&sigunguCode=&cat1=C01&cat2=C0116&cat3=C01160001";
		// (147) String coupleUrl =
		// "http://apis.data.go.kr/B551011/KorService1/areaBasedList1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey="+serviceKey+"&listYN=Y&arrange=A&contentTypeId=&areaCode=&sigunguCode=&cat1=C01&cat2=C0114&cat3=C01140001";
		// (54)String aloneUrl =
		// "http://apis.data.go.kr/B551011/KorService1/areaBasedList1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey="+serviceKey+"&listYN=Y&arrange=A&contentTypeId=&areaCode=&sigunguCode=&cat1=C01&cat2=C0113&cat3=C01130001";
		// (36)String familyUrl =
		// "http://apis.data.go.kr/B551011/KorService1/areaBasedList1?numOfRows=12&pageNo=1&MobileOS=ETC&MobileApp=AppTest&ServiceKey="+serviceKey+"&listYN=Y&arrange=A&contentTypeId=&areaCode=&sigunguCode=&cat1=C01&cat2=C0112&cat3=C01120001";
		String serviceKey = "gyesYtRw%2BO5TYGJgK%2FiI%2FFD6htVqBdnM8lz7Qp2noL4lQCWtcnA%2BWzJ9dWkBu0dMagfS1sVHzJi3Vn8CQaqM%2Fw%3D%3D";
		String[] themeList = new String[] { "friends", "couple", "alone", "family" };
		String[] cat2List = new String[] { "C0116", "C0114", "C0113", "C0112" };
		String[] cat3List = new String[] { "C01160001", "C01140001", "C01130001", "C01120001" };

		for (int i = 0; i < themeList.length; i++) {
			urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/areaBasedList1");

			urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + serviceKey);
			urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("100", "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("AppTest", "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("arrange", "UTF-8") + "=" + URLEncoder.encode("O", "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("cat1", "UTF-8") + "=" + URLEncoder.encode("C01", "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("cat2", "UTF-8") + "=" + URLEncoder.encode(cat2List[i], "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("cat3", "UTF-8") + "=" + URLEncoder.encode(cat3List[i], "UTF-8"));

			url(urlBuilder);

			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(String.valueOf(urlBuilder));

			NodeList nList = doc.getElementsByTagName("item");
			ArrayList<Integer> contentIdList = new ArrayList<Integer>();
			ArrayList<Integer> contentTypeIdList = new ArrayList<Integer>();

			for (int temp = 0; temp < nList.getLength(); temp++) {
				Node nNode = nList.item(temp);

				if (nNode.getNodeType() == Node.ELEMENT_NODE) {
					Element eElement = (Element) nNode;

					int contentId = Integer.valueOf(getValue("contentid", eElement));
					Integer contentTypeId = Integer.valueOf(getValue("contenttypeid", eElement));
					contentTypeIdList.add(contentTypeId);
					contentIdList.add(contentId);

				} // if
					// System.out.println(contentIdList.get(i));
			} // for
				// arraylist 잘 들어갔는지 확인용: System.out.println(contentIdList.size());
			System.out.println("테마게시글 id 저장 성공");
			getThemeInfo(contentIdList, contentTypeIdList, themeList[i]); // 기본 정보 DB 등록 - 장소명, 테마, id

		} // url for
	}// test method

	// 테마 장소 불러오기 -> 장소 arrayList 가져와서 상세정보 insert(for문)
	public void getThemeInfo(ArrayList<Integer> contentIdList, ArrayList<Integer> contentTypeIdList, String theme)
			throws Exception {

		for (int i = 0; i < contentIdList.size(); i++) {
			urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/detailInfo1");
			urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + serviceKey);
			urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8"));
			urlBuilder.append(
					"&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("AppTest", "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("contentTypeId", "UTF-8") + "="
					+ URLEncoder.encode(String.valueOf(contentTypeIdList.get(i)), "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("contentId", "UTF-8") + "="
					+ URLEncoder.encode(String.valueOf(contentIdList.get(i)), "UTF-8"));

			url(urlBuilder);

			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(urlBuilder.toString());

			NodeList nList = doc.getElementsByTagName("item");

			for (int temp = 0; temp < nList.getLength(); temp++) {
				Node nNode = nList.item(temp);

				if (nNode.getNodeType() == Node.ELEMENT_NODE) {
					Element eElement = (Element) nNode;

					int contentId = Integer.valueOf(getValue("subcontentid", eElement));
					String title = getValue("subname", eElement);

					PlaceDTO placeDTO = new PlaceDTO(contentId, title, theme);
					// DB 저장 확인용: System.out.println(placeDTO.contentId +" , "+contentTypeId);

					// DB 해당 content 존재하는지 확인(문제)
					if (!StringUtils.hasText(placemapper.selectPlaceId(placeDTO.contentId))) { // 기존 데이터 없는경우
						System.out.println("기존데이터x");
						placemapper.insertThemeBasicInfo(placeDTO); // 아이디, 제목, 테마 저장
						getThemePlaceDetail(contentId); // 기본정보 불러오기: 상세정보 불러오기 포함되어 있음
					}
					System.out.println("기존 place 데이터o");
					if (!StringUtils.hasText(placemapper.selectContentId(contentId))) { // contents테이블 정보 없는 경우
						getThemePlaceDetail(contentId); // 기본정보 불러오기: 상세정보 불러오기 포함되어 있음
					}
				} // if
			} // for

		} // contentIdList for

	}// test method

	// 테마 장소 불러오기2 -> 장소 arrayList 가져와서 상세정보 insert(for문)
	public void getThemeInfo2(ArrayList<Integer> contentIdList, ArrayList<Integer> contentTypeIdList, String theme)
			throws Exception {

		for (int i = 0; i < contentIdList.size(); i++) {
			urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/detailInfo1");
			urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + serviceKey);
			urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8"));
			urlBuilder.append(
					"&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("AppTest", "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("contentTypeId", "UTF-8") + "="
					+ URLEncoder.encode(String.valueOf(contentTypeIdList.get(i)), "UTF-8"));
			urlBuilder.append("&" + URLEncoder.encode("contentId", "UTF-8") + "="
					+ URLEncoder.encode(String.valueOf(contentIdList.get(i)), "UTF-8"));

			url(urlBuilder);

			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(urlBuilder.toString());

			NodeList nList = doc.getElementsByTagName("item");

			for (int temp = 0; temp < nList.getLength(); temp++) {
				Node nNode = nList.item(temp);

				if (nNode.getNodeType() == Node.ELEMENT_NODE) {
					Element eElement = (Element) nNode;

					int contentId = Integer.valueOf(getValue("subcontentid", eElement));
					String title = getValue("subname", eElement);

					PlaceDTO placeDTO = new PlaceDTO(contentId, title, theme);
					// DB 저장 확인용: System.out.println(placeDTO.contentId +" , "+contentTypeId);

					// DB 해당 content 존재하는지 확인(문제)
					if (!StringUtils.hasText(placemapper.selectPlaceId2(placeDTO.contentId))) { // 기존 데이터 없는경우
						System.out.println("기존데이터x");
						placemapper.insertThemeBasicInfo2(placeDTO); // 아이디, 제목, 테마 저장
						getThemePlaceDetail2(contentId); // 기본정보 불러오기: 상세정보 불러오기 포함되어 있음
					}
					System.out.println("기존 place 데이터o");
					if (!StringUtils.hasText(placemapper.selectContentId2(contentId))) { // contents테이블 정보 없는 경우
						getThemePlaceDetail2(contentId); // 기본정보 불러오기: 상세정보 불러오기 포함되어 있음
					}
				} // if
			} // for

		} // contentIdList for

	}// test method

	// 장소별 기본정보 불러오기
	public void getThemePlaceDetail(int placeContentId) throws Exception {
		System.out.println(placeContentId);

		urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/detailCommon1");
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + serviceKey);
		urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("100", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("test", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("contentId", "UTF-8") + "="
				+ URLEncoder.encode(String.valueOf(placeContentId), "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("overviewYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 개요
		urlBuilder.append("&" + URLEncoder.encode("addrinfoYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 주소
		urlBuilder.append("&" + URLEncoder.encode("mapinfoYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 좌표
		urlBuilder.append("&" + URLEncoder.encode("areacodeYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 지역코드
		urlBuilder.append("&" + URLEncoder.encode("firstImageYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 대표이미지
		urlBuilder.append("&" + URLEncoder.encode("defaultYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 기본정보

		url(urlBuilder);

		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(String.valueOf(urlBuilder));

		NodeList nodeList = doc.getElementsByTagName("item"); // xml 태그 이름 중 <item>인 부분을 전부 가져온다(NodeList 타입)

		if (nodeList.item(0) != null) {
			Node node = nodeList.item(0); // 모든 <item> 태그 중 첫번째 node

			if (node.getNodeType() == Node.ELEMENT_NODE) { // 자식 노드가 요소일 경우에만 실행한다
				Element e = (Element) node;

				System.out.println("테마장소별 기본정보 불러오기");

				// null체크
				Integer contentId = Integer.parseInt(getValue("contentid", e)); // 게시물 id
				Integer contenttypeid = Integer.parseInt(getValue("contenttypeid", e)); // 게시물 타입 id
				String title = getValue("title", e);
				Integer areaCode = Integer.parseInt(getValue("areacode", e));
				String image1 = getValue("firstimage", e);
				String addr1 = getValue("addr1", e);
				String addr2 = getValue("addr2", e);
				Double mapx = Double.parseDouble(getValue("mapx", e));
				Double mapy = Double.parseDouble(getValue("mapy", e));
				String contents = getValue("overview", e);
				String homepage = getValue("homepage", e);

				PlaceDTO placedto = new PlaceDTO();
				placedto.contentId = contentId;
				placedto.contentTypeId = contenttypeid;
				placedto.title = title;
				placedto.areaCode = areaCode;
				placedto.image1 = image1;
				if (addr2 != null) {
					placedto.address = addr1.concat(addr2);
				} else {
					placedto.address = addr1;
				}
				placedto.mapx = mapx;
				placedto.mapy = mapy;
				placedto.contents = contents;
				placedto.homepage = homepage;

				placemapper.updateThemePlace(placedto);
				System.out.println("테마장소별 기본정보 수정");

				getThemePlaceDetailIntro(placedto.contentId, placedto.contentTypeId);
			} // if
		}
	}// method

	// 장소별 기본정보 불러오기2
	public void getThemePlaceDetail2(int placeContentId) throws Exception {
		System.out.println(placeContentId);

		urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/detailCommon1");
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + serviceKey);
		urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("100", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("test", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("contentId", "UTF-8") + "="
				+ URLEncoder.encode(String.valueOf(placeContentId), "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("overviewYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 개요
		urlBuilder.append("&" + URLEncoder.encode("addrinfoYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 주소
		urlBuilder.append("&" + URLEncoder.encode("mapinfoYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 좌표
		urlBuilder.append("&" + URLEncoder.encode("areacodeYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 지역코드
		urlBuilder.append("&" + URLEncoder.encode("firstImageYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 대표이미지
		urlBuilder.append("&" + URLEncoder.encode("defaultYN", "UTF-8") + "=" + URLEncoder.encode("Y", "UTF-8")); // 기본정보

		url(urlBuilder);

		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(String.valueOf(urlBuilder));

		NodeList nodeList = doc.getElementsByTagName("item"); // xml 태그 이름 중 <item>인 부분을 전부 가져온다(NodeList 타입)

		if (nodeList.item(0) != null) {
			Node node = nodeList.item(0); // 모든 <item> 태그 중 첫번째 node

			if (node.getNodeType() == Node.ELEMENT_NODE) { // 자식 노드가 요소일 경우에만 실행한다
				Element e = (Element) node;

				System.out.println("테마장소별 기본정보 불러오기");

				// null체크
				Integer contentId = Integer.parseInt(getValue("contentid", e)); // 게시물 id
				Integer contenttypeid = Integer.parseInt(getValue("contenttypeid", e)); // 게시물 타입 id
				String title = getValue("title", e);
				Integer areaCode = Integer.parseInt(getValue("areacode", e));
				String image1 = getValue("firstimage", e);
				String addr1 = getValue("addr1", e);
				String addr2 = getValue("addr2", e);
				Double mapx = Double.parseDouble(getValue("mapx", e));
				Double mapy = Double.parseDouble(getValue("mapy", e));
				String contents = getValue("overview", e);
				String homepage = getValue("homepage", e);

				PlaceDTO placedto = new PlaceDTO();
				placedto.contentId = contentId;
				placedto.contentTypeId = contenttypeid;
				placedto.title = title;
				placedto.areaCode = areaCode;
				placedto.image1 = image1;
				if (addr2 != null) {
					placedto.address = addr1.concat(addr2);
				} else {
					placedto.address = addr1;
				}
				placedto.mapx = mapx;
				placedto.mapy = mapy;
				placedto.contents = contents;
				placedto.homepage = homepage;

				placemapper.updateThemePlace2(placedto);
				System.out.println("테마장소별 기본정보 수정");

				getThemePlaceDetailIntro2(placedto.contentId, placedto.contentTypeId);
			} // if
		}
	}// method

	// 장소별 상세정보 불러오기
	public void getThemePlaceDetailIntro(int placeContentId, int placeContentTypeId) throws Exception {

		urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/detailIntro1");
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + serviceKey);
		urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("test", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("contentId", "UTF-8") + "="
				+ URLEncoder.encode(String.valueOf(placeContentId), "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("contentTypeId", "UTF-8") + "="
				+ URLEncoder.encode(String.valueOf(placeContentTypeId), "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8"));
		url(urlBuilder);

		System.out.println(urlBuilder); // 확인용

		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(String.valueOf(urlBuilder));

		NodeList nodeList = doc.getElementsByTagName("item"); // xml 태그 이름 중 <item>인 부분을 전부 가져온다(NodeList 타입)

		if (nodeList.item(0) != null) {
			Node node = nodeList.item(0); // 모든 <item> 태그 중 첫번째 node

			if (node.getNodeType() == Node.ELEMENT_NODE) { // 자식 노드가 요소일 경우에만 실행한다
				Element e = (Element) node;

				ContentsDTO contentsdto;

				if (placeContentTypeId == 12) {
					contentsdto = getContentType_12(e);
					ThemeDetail(placeContentId, contentsdto);
					System.out.println("");
				}
				if (placeContentTypeId == 39) {
					contentsdto = getContentType_39(e);
					ThemeDetail(placeContentId, contentsdto);
				}
				if (placeContentTypeId == 14) {
					contentsdto = getContentType_14(e);
					ThemeDetail(placeContentId, contentsdto);
				}
				if (placeContentTypeId == 28) {
					contentsdto = getContentType_28(e);
					ThemeDetail(placeContentId, contentsdto);
				}

			} // if문

		}

	}// method
	// 장소별 상세정보 불러오기2

	public void getThemePlaceDetailIntro2(int placeContentId, int placeContentTypeId) throws Exception {

		urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorService1/detailIntro1");
		urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + serviceKey);
		urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("test", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("contentId", "UTF-8") + "="
				+ URLEncoder.encode(String.valueOf(placeContentId), "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("contentTypeId", "UTF-8") + "="
				+ URLEncoder.encode(String.valueOf(placeContentTypeId), "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8"));
		urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8"));
		url(urlBuilder);

		System.out.println(urlBuilder); // 확인용

		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(String.valueOf(urlBuilder));

		NodeList nodeList = doc.getElementsByTagName("item"); // xml 태그 이름 중 <item>인 부분을 전부 가져온다(NodeList 타입)

		if (nodeList.item(0) != null) {
			Node node = nodeList.item(0); // 모든 <item> 태그 중 첫번째 node

			if (node.getNodeType() == Node.ELEMENT_NODE) { // 자식 노드가 요소일 경우에만 실행한다
				Element e = (Element) node;

				ContentsDTO contentsdto;

				if (placeContentTypeId == 12) {
					contentsdto = getContentType_12(e);
					ThemeDetail2(placeContentId, contentsdto);
				}
				if (placeContentTypeId == 39) {
					contentsdto = getContentType_39(e);
					ThemeDetail2(placeContentId, contentsdto);
				}
				if (placeContentTypeId == 14) {
					contentsdto = getContentType_14(e);
					ThemeDetail2(placeContentId, contentsdto);
				}
				if (placeContentTypeId == 28) {
					contentsdto = getContentType_28(e);
					ThemeDetail2(placeContentId, contentsdto);
				}

			} // if문

		}

	}// method

	public void ThemeDetail(int placeContentId, ContentsDTO contentsdto) {
		if (StringUtils.hasText(placemapper.selectContentId(placeContentId))) {// 기존데이터 존재
			placemapper.updateThemeDetail(contentsdto);
			System.out.println("contents테이블 update");
		} else {
			placemapper.insertThemeDetail(contentsdto); // contents 테이블에 기존 데이터 없을 경우
			System.out.println("contents테이블 insert");
		}
	}

	public void ThemeDetail2(int placeContentId, ContentsDTO contentsdto) {
		if (StringUtils.hasText(placemapper.selectContentId2(placeContentId))) {// 기존데이터 존재
			placemapper.updateThemeDetail2(contentsdto);
		} else {
			placemapper.insertThemeDetail2(contentsdto); // contents 테이블에 기존 데이터 없을 경우
		}
	}

	public void url(StringBuilder urlBuilder) throws Exception {
		URL url = new URL(urlBuilder.toString());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-type", "application/json");

		System.out.println("Response code: " + conn.getResponseCode());
		BufferedReader rd;
		if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
			rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		} else {
			rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
		}

		StringBuilder sb = new StringBuilder(); // 변경 가능한 문자열: StringBuilder
		String line;
		while ((line = rd.readLine()) != null) {
			sb.append(line);
		}
		rd.close();
		conn.disconnect();

		String result = sb.toString();
		System.out.println(result);
	}

	public ContentsDTO getContentType_14(Element e) { // 문화시설

		Integer contentId = Integer.parseInt(getValue("contentid", e));
		String accomcount = getValue("accomcountculture", e); // 문의 및 안내
		String chkbabycarriage = getValue("chkbabycarriageculture", e); // 유모차 대여
		String chkcreditcard = getValue("chkcreditcardculture", e);
		String chkpet = getValue("chkpetculture", e);
		String infocenter = getValue("infocenterculture", e);
		String parking = getValue("parkingculture", e);
		String parkingfee = getValue("parkingfee", e); // 문의 및 안내
		String restdate = getValue("restdateculture", e); // 유모차 대여
		String usefee = getValue("usefee", e);
		String discountinfo = getValue("discountinfo", e);
		String usetime = getValue("usetimeculture", e);

		ContentsDTO Contentsdto = new ContentsCultureDTO(contentId, infocenter, chkbabycarriage, chkcreditcard, chkpet,
				accomcount, parking, parkingfee, restdate, usefee, discountinfo, usetime);

		return Contentsdto;
	}

	public ContentsDTO getContentType_28(Element e) { // 레포츠

		// null체크
		Integer contentId = Integer.parseInt(getValue("contentid", e));
		String infocenter = getValue("infocenterleports", e);
		String chkbabycarriage = getValue("chkbabycarriageleports", e);
		String chkcreditcard = getValue("chkcreditcardleports", e);
		String chkpet = getValue("chkpetleports", e);
		String restdate = getValue("restdateleports", e);
		String usetime = getValue("usetimeleports", e);
		String accomcount = getValue("accomcountleports", e);
		String usefee = getValue("usefeeleports", e);
		String parkingfee = getValue("parkingfeeleports", e);
		String reservationinfo = getValue("reservation", e);

		ContentsDTO Contentsdto = new ContentsLeportsDTO(contentId, infocenter, chkbabycarriage, chkcreditcard, chkpet,
				restdate, usetime, accomcount, usefee, parkingfee, parkingfee, reservationinfo);

		return Contentsdto;
	}

	public ContentsDTO getContentType_12(Element e) { // 관광지

		// null체크
		Integer contentId = Integer.parseInt(getValue("contentid", e));
		String infocenter = getValue("infocenter", e); // 문의 및 안내
		String chkbabycarriage = getValue("chkbabycarriage", e); // 유모차 대여
		String chkpet = getValue("chkpet", e);
		String chkcreditcard = getValue("chkcreditcard", e);
		String restdate = getValue("restdate", e);
		String usetime = getValue("usetime", e);

		ContentsDTO Contentsdto = new ContentsTourDTO(contentId, infocenter, chkbabycarriage, chkcreditcard, chkpet,
				restdate, usetime);
		return Contentsdto;
	}

	public ContentsDTO getContentType_39(Element e) { // 식당

		// null체크
		Integer contentId = Integer.parseInt(getValue("contentid", e));
		String infocenter = getValue("infocenterfood", e); // 문의 및 안내
		String chkcreditcard = getValue("chkcreditcardfood", e); // 신용카드
		String discountinfo = getValue("discountinfofood", e); // 할인정보
		String firstmenu = getValue("firstmenu", e); // 대표메뉴
		String reservationinfo = getValue("reservationfood", e); // 예약안내
		String restdate = getValue("restdatefood", e);// 쉬는날
		String takeout = getValue("packing", e); // 포장가능
		String parking = getValue("parkingfood", e); // 주차시설
		String kidsfacility = getValue("kidsfacility", e);// 어린이놀이방여부
		String usetime = getValue("opentimefood", e);

		ContentsDTO Contentsdto = new ContentsFoodDTO(contentId, infocenter, kidsfacility, chkcreditcard, restdate,
				usetime, discountinfo, firstmenu, reservationinfo, takeout, parking);
		return Contentsdto;
	}

	private static String getValue(String tag, Element element) {
		// 태그 이름이 매개변수인 노드를 찾아 > 찾은 노드에서 n번째 노드에 접근 > n번째 노드 안에 정보에 접근할 수 있는 nodelist
		String result = null;

		if (element.getElementsByTagName(tag).item(0).getChildNodes() != null) {
			NodeList nodes = element.getElementsByTagName(tag).item(0).getChildNodes();
			// Node node = (Node) nodes.item(0);
			if ((Node) nodes.item(0) != null) {
				result = ((Node) nodes.item(0)).getNodeValue();
			}
		}
		return result;
	}

}// class
