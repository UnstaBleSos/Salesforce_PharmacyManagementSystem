@isTest
public class UserInfoControllerTest {
    @isTest
    static void testGetUserProfileName() {
        Test.startTest();
        String profileName = UserInfoController.getUserProfileName();
        Test.stopTest();
        System.assertNotEquals(null, profileName, 'Profile name should not be null');
    }
}
