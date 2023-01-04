class PancardResponse {
    String baseUrl;
    String message;
    String pancard_image;
    int statusCode;
    bool success;
    UserDetails userDetails;

    PancardResponse({this.baseUrl, this.message, this.pancard_image, this.statusCode, this.success, this.userDetails});

    factory PancardResponse.fromJson(Map<String, dynamic> json) {
        return PancardResponse(
            baseUrl: json['baseUrl'],
            message: json['message'],
            pancard_image: json['pancard_image'],
            statusCode: json['statusCode'],
            success: json['success'],
            userDetails: json['userDetails'] != null ? UserDetails.fromJson(json['userDetails']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['baseUrl'] = this.baseUrl;
        data['message'] = this.message;
        data['pancard_image'] = this.pancard_image;
        data['statusCode'] = this.statusCode;
        data['success'] = this.success;
        if (this.userDetails != null) {
            data['userDetails'] = this.userDetails.toJson();
        }
        return data;
    }
}

class UserDetails {
    int country_code;
    Object customer_id;
    String date_of_birth;
    String email;
    int id;
    String image_url;
    ModifiedAt modified_at;
    String name;
    String pancard_image;
    String phone_number;
    int points;
    Object username;

    UserDetails({this.country_code, this.customer_id, this.date_of_birth, this.email, this.id, this.image_url, this.modified_at, this.name, this.pancard_image, this.phone_number, this.points, this.username});

    factory UserDetails.fromJson(Map<String, dynamic> json) {
        return UserDetails(
            country_code: json['country_code'],
            date_of_birth: json['date_of_birth'],
            email: json['email'],
            id: json['id'],
            image_url: json['image_url'],
            name: json['name'],
            pancard_image: json['pancard_image'],
            phone_number: json['phone_number'],
            points: json['points'],
            //username: json['username'] != null ? Object.fromJson(json['username']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['country_code'] = this.country_code;
        data['date_of_birth'] = this.date_of_birth;
        data['email'] = this.email;
        data['id'] = this.id;
        data['image_url'] = this.image_url;
        data['name'] = this.name;
        data['pancard_image'] = this.pancard_image;
        data['phone_number'] = this.phone_number;
        data['points'] = this.points;

        if (this.modified_at != null) {
            data['modified_at'] = this.modified_at.toJson();
        }

        return data;
    }
}

class ModifiedAt {
    String expression;
    List<Object> params;

    ModifiedAt({this.expression, this.params});

    // factory ModifiedAt.fromJson(Map<String, dynamic> json) {
    //     return ModifiedAt(
    //         expression: json['expression'],
    //         params: json['params'] != null ? (json['params'] as List).map((i) => Object.fromJson(i)).toList() : null,
    //     );
    // }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['expression'] = this.expression;

        return data;
    }
}