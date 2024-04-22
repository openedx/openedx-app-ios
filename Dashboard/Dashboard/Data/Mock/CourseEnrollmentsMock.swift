//
//  CourseEnrollmentsMock.swift
//  Dashboard
//
//  Created by Shafqat Muneer on 2/12/24.
//

import Foundation

// Mark - For testing and SwiftUI preview
// swiftlint:disable all
#if DEBUG
extension DashboardRepository {
    static let CourseEnrollmentsJSON: String = """
    {
      "enrollments": {
        "next": null,
        "previous": null,
        "count": 114,
        "num_pages": 1,
        "current_page": 1,
        "start": 0,
        "results": [
          {
            "audit_access_expires": "2024-03-05T05:23:03Z",
            "created": "2024-02-06T05:23:03Z",
            "mode": "audit",
            "is_active": true,
            "course": {
              "id": "course-v1:ZHAWx+SCF1+1T2024",
              "name": "Sustainable Corporate Financing: Foundations",
              "number": "1",
              "org": "ZHAWx",
              "start": "2024-02-05T11:00:00Z",
              "start_display": "Feb. 5, 2024",
              "start_type": "timestamp",
              "end": "2024-07-07T10:00:00Z",
              "dynamic_upgrade_deadline": "2024-06-27T23:59:59Z",
              "subscription_id": "course_MNXXK4TTMUWXMMJ2LJEECV3YFNJUGRRRFMYVIMRQGI2A____",
              "courseware_access": {
                "has_access": true,
                "error_code": null,
                "developer_message": null,
                "user_message": null,
                "additional_context_user_message": null,
                "user_fragment": null
              },
              "media": {
                "course_image": {
                  "uri": "/asset-v1:ZHAWx+SCF1+1T2024+type@asset+block@course_image.png",
                  "name": "Course Image"
                }
              },
              "course_image": "/asset-v1:ZHAWx+SCF1+1T2024+type@asset+block@course_image.png",
              "course_about": "https://www.edx.org/course/sustainable-corporate-financing-foundations-course-v1-zhawx-scf1-1t2024",
              "course_sharing_utm_parameters": {
                "facebook": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=facebook",
                "twitter": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=twitter"
              },
              "course_updates": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:ZHAWx+SCF1+1T2024/updates",
              "course_handouts": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:ZHAWx+SCF1+1T2024/handouts",
              "discussion_url": "https://courses.edx.org/api/discussion/v1/courses/course-v1:ZHAWx+SCF1+1T2024",
              "video_outline": null,
              "is_self_paced": false
            },
            "certificate": {
              
            },
            "course_modes": [
              {
                "slug": "audit",
                "sku": "08D0410",
                "android_sku": null,
                "ios_sku": null
              },
              {
                "slug": "verified",
                "sku": "6D7CAF1",
                "android_sku": null,
                "ios_sku": null
              }
            ]
          },
          {
            "audit_access_expires": "2024-03-01T11:40:45Z",
            "created": "2024-02-02T11:40:45Z",
            "mode": "audit",
            "is_active": true,
            "course": {
              "id": "course-v1:ZHAWx+SCF2+2T2023",
              "name": "Sustainable Corporate Financing: Application",
              "number": "1",
              "org": "ZHAWx",
              "start": "2023-08-07T10:00:00Z",
              "start_display": "Aug. 7, 2023",
              "start_type": "timestamp",
              "end": "2024-02-04T23:59:00Z",
              "dynamic_upgrade_deadline": null,
              "subscription_id": "course_MNXXK4TTMUWXMMJ2LJEECV3YFNJUGRRSFMZFIMRQGIZQ____",
              "courseware_access": {
                "has_access": true,
                "error_code": null,
                "developer_message": null,
                "user_message": null,
                "additional_context_user_message": null,
                "user_fragment": null
              },
              "media": {
                "course_image": {
                  "uri": "/asset-v1:ZHAWx+SCF2+2T2023+type@asset+block@course_image.png",
                  "name": "Course Image"
                }
              },
              "course_image": "/asset-v1:ZHAWx+SCF2+2T2023+type@asset+block@course_image.png",
              "course_about": "https://www.edx.org/course/sustainable-corporate-financing-application-course-v1-zhawx-scf2-2t2023",
              "course_sharing_utm_parameters": {
                "facebook": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=facebook",
                "twitter": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=twitter"
              },
              "course_updates": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:ZHAWx+SCF2+2T2023/updates",
              "course_handouts": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:ZHAWx+SCF2+2T2023/handouts",
              "discussion_url": "https://courses.edx.org/api/discussion/v1/courses/course-v1:ZHAWx+SCF2+2T2023",
              "video_outline": null,
              "is_self_paced": false
            },
            "certificate": {
              
            },
            "course_modes": [
              {
                "slug": "audit",
                "sku": "C748313",
                "android_sku": null,
                "ios_sku": null
              }
            ]
          },
          {
            "audit_access_expires": "2024-03-29T11:40:07Z",
            "created": "2024-02-02T11:40:07Z",
            "mode": "audit",
            "is_active": true,
            "course": {
              "id": "course-v1:FedericaX+50+3T2020a",
              "name": "Robotics Foundations I - Robot Modeling",
              "number": "50",
              "org": "FedericaX",
              "start": "2020-10-19T10:00:00Z",
              "start_display": "Oct. 19, 2020",
              "start_type": "timestamp",
              "end": "2024-12-31T10:00:00Z",
              "dynamic_upgrade_deadline": "2024-12-21T23:59:59Z",
              "subscription_id": "course_MNXXK4TTMUWXMMJ2IZSWIZLSNFRWCWBLGUYCWM2UGIYDEMDB",
              "courseware_access": {
                "has_access": true,
                "error_code": null,
                "developer_message": null,
                "user_message": null,
                "additional_context_user_message": null,
                "user_fragment": null
              },
              "media": {
                "course_image": {
                  "uri": "/asset-v1:FedericaX+50+3T2020a+type@asset+block@course_image.jpg",
                  "name": "Course Image"
                }
              },
              "course_image": "/asset-v1:FedericaX+50+3T2020a+type@asset+block@course_image.jpg",
              "course_about": "https://www.edx.org/course/robotics-foundations-i-robot-modeling-course-v1federicax503t2020a",
              "course_sharing_utm_parameters": {
                "facebook": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=facebook",
                "twitter": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=twitter"
              },
              "course_updates": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:FedericaX+50+3T2020a/updates",
              "course_handouts": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:FedericaX+50+3T2020a/handouts",
              "discussion_url": "https://courses.edx.org/api/discussion/v1/courses/course-v1:FedericaX+50+3T2020a",
              "video_outline": null,
              "is_self_paced": false
            },
            "certificate": {
              
            },
            "course_modes": [
              {
                "slug": "audit",
                "sku": "F84F145",
                "android_sku": null,
                "ios_sku": null
              },
              {
                "slug": "verified",
                "sku": "7B00BCC",
                "android_sku": "mobile.android.7b00bcc",
                "ios_sku": "mobile.ios.7b00bcc"
              }
            ]
          },
          {
            "audit_access_expires": "2024-02-26T15:05:37Z",
            "created": "2024-01-29T15:05:37Z",
            "mode": "audit",
            "is_active": true,
            "course": {
              "id": "course-v1:ZHAWx+SCF1+2T2023",
              "name": "Sustainable Corporate Financing: Foundations",
              "number": "1",
              "org": "ZHAWx",
              "start": "2023-08-07T10:00:00Z",
              "start_display": "Aug. 7, 2023",
              "start_type": "timestamp",
              "end": "2024-02-04T23:59:00Z",
              "dynamic_upgrade_deadline": null,
              "subscription_id": "course_MNXXK4TTMUWXMMJ2LJEECV3YFNJUGRRRFMZFIMRQGIZQ____",
              "courseware_access": {
                "has_access": true,
                "error_code": null,
                "developer_message": null,
                "user_message": null,
                "additional_context_user_message": null,
                "user_fragment": null
              },
              "media": {
                "course_image": {
                  "uri": "/asset-v1:ZHAWx+SCF1+2T2023+type@asset+block@course_image.png",
                  "name": "Course Image"
                }
              },
              "course_image": "/asset-v1:ZHAWx+SCF1+2T2023+type@asset+block@course_image.png",
              "course_about": "https://www.edx.org/course/sustainable-corporate-financing-foundations-course-v1-zhawx-scf1-2t2023",
              "course_sharing_utm_parameters": {
                "facebook": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=facebook",
                "twitter": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=twitter"
              },
              "course_updates": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:ZHAWx+SCF1+2T2023/updates",
              "course_handouts": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:ZHAWx+SCF1+2T2023/handouts",
              "discussion_url": "https://courses.edx.org/api/discussion/v1/courses/course-v1:ZHAWx+SCF1+2T2023",
              "video_outline": null,
              "is_self_paced": false
            },
            "certificate": {
              
            },
            "course_modes": [
              {
                "slug": "audit",
                "sku": "E059A8E",
                "android_sku": null,
                "ios_sku": null
              }
            ]
          },
          {
            "audit_access_expires": "2024-02-21T09:08:25Z",
            "created": "2024-01-24T09:08:25Z",
            "mode": "audit",
            "is_active": true,
            "course": {
              "id": "course-v1:USMx+PGPM661.4x+2T2022",
              "name": "Creating an Organizational Change Management Framework - Transforming Strategy Execution to Realize Program Value",
              "number": "PGPM661.4x",
              "org": "USMx",
              "start": "2022-11-01T16:00:00Z",
              "start_display": "Nov. 1, 2022",
              "start_type": "timestamp",
              "end": "2024-07-31T16:00:00Z",
              "dynamic_upgrade_deadline": "2024-07-21T23:59:59Z",
              "subscription_id": "course_MNXXK4TTMUWXMMJ2KVJU26BLKBDVATJWGYYS4NDYFMZFIMRQGIZA____",
              "courseware_access": {
                "has_access": true,
                "error_code": null,
                "developer_message": null,
                "user_message": null,
                "additional_context_user_message": null,
                "user_fragment": null
              },
              "media": {
                "course_image": {
                  "uri": "/asset-v1:USMx+PGPM661.4x+2T2022+type@asset+block@course_image.png",
                  "name": "Course Image"
                }
              },
              "course_image": "/asset-v1:USMx+PGPM661.4x+2T2022+type@asset+block@course_image.png",
              "course_about": "https://www.edx.org/course/benefits-realization-management-brm-linking-strategy-execution-to-achieving-value-course-v1usmxpgpm6614x2t2022",
              "course_sharing_utm_parameters": {
                "facebook": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=facebook",
                "twitter": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=twitter"
              },
              "course_updates": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:USMx+PGPM661.4x+2T2022/updates",
              "course_handouts": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:USMx+PGPM661.4x+2T2022/handouts",
              "discussion_url": "https://courses.edx.org/api/discussion/v1/courses/course-v1:USMx+PGPM661.4x+2T2022",
              "video_outline": null,
              "is_self_paced": false
            },
            "certificate": {
              
            },
            "course_modes": [
              {
                "slug": "audit",
                "sku": "C08ED36",
                "android_sku": null,
                "ios_sku": null
              },
              {
                "slug": "verified",
                "sku": "10E91CB",
                "android_sku": null,
                "ios_sku": null
              }
            ]
          },
          {
            "audit_access_expires": "2024-02-21T09:08:05Z",
            "created": "2024-01-24T09:08:05Z",
            "mode": "audit",
            "is_active": true,
            "course": {
              "id": "course-v1:USMx+PGPM661.3x+2T2022",
              "name": "The Program Management Office (PMO) - The Strategy Execution Arm",
              "number": "PGPM661.3x",
              "org": "USMx",
              "start": "2022-07-13T16:30:00Z",
              "start_display": "July 13, 2022",
              "start_type": "timestamp",
              "end": "2024-07-31T16:00:00Z",
              "dynamic_upgrade_deadline": "2024-07-21T23:59:59Z",
              "subscription_id": "course_MNXXK4TTMUWXMMJ2KVJU26BLKBDVATJWGYYS4M3YFMZFIMRQGIZA____",
              "courseware_access": {
                "has_access": true,
                "error_code": null,
                "developer_message": null,
                "user_message": null,
                "additional_context_user_message": null,
                "user_fragment": null
              },
              "media": {
                "course_image": {
                  "uri": "/asset-v1:USMx+PGPM661.3x+2T2022+type@asset+block@course_image.png",
                  "name": "Course Image"
                }
              },
              "course_image": "/asset-v1:USMx+PGPM661.3x+2T2022+type@asset+block@course_image.png",
              "course_about": "https://www.edx.org/course/the-program-management-office-pmo-the-strategy-execution-arm-course-v1usmxpgpm6613x2t2022",
              "course_sharing_utm_parameters": {
                "facebook": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=facebook",
                "twitter": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=twitter"
              },
              "course_updates": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:USMx+PGPM661.3x+2T2022/updates",
              "course_handouts": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:USMx+PGPM661.3x+2T2022/handouts",
              "discussion_url": "https://courses.edx.org/api/discussion/v1/courses/course-v1:USMx+PGPM661.3x+2T2022",
              "video_outline": null,
              "is_self_paced": false
            },
            "certificate": {
              
            },
            "course_modes": [
              {
                "slug": "audit",
                "sku": "22F61B0",
                "android_sku": null,
                "ios_sku": null
              },
              {
                "slug": "verified",
                "sku": "28D953F",
                "android_sku": null,
                "ios_sku": null
              }
            ]
          },
          {
            "audit_access_expires": "2024-05-27T23:59:00Z",
            "created": "2024-01-23T07:45:17Z",
            "mode": "audit",
            "is_active": true,
            "course": {
              "id": "course-v1:MITx+18.6501x+1T2024",
              "name": "Fundamentals of Statistics",
              "number": "18.6501x",
              "org": "MITx",
              "start": "2024-01-29T23:59:00Z",
              "start_display": "January 29, 2024",
              "start_type": "string",
              "end": "2024-05-25T23:59:00Z",
              "dynamic_upgrade_deadline": "2024-03-29T12:00:00Z",
              "subscription_id": "course_MNXXK4TTMUWXMMJ2JVEVI6BLGE4C4NRVGAYXQKZRKQZDAMRU",
              "courseware_access": {
                "has_access": true,
                "error_code": null,
                "developer_message": null,
                "user_message": null,
                "additional_context_user_message": null,
                "user_fragment": null
              },
              "media": {
                "course_image": {
                  "uri": "/asset-v1:MITx+18.6501x+1T2024+type@asset+block@course_image.jpg",
                  "name": "Course Image"
                }
              },
              "course_image": "/asset-v1:MITx+18.6501x+1T2024+type@asset+block@course_image.jpg",
              "course_about": "https://www.edx.org/course/fundamentals-of-statistics-course-v1-mitx-18-6501x-1t2024",
              "course_sharing_utm_parameters": {
                "facebook": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=facebook",
                "twitter": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=twitter"
              },
              "course_updates": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:MITx+18.6501x+1T2024/updates",
              "course_handouts": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:MITx+18.6501x+1T2024/handouts",
              "discussion_url": "https://courses.edx.org/api/discussion/v1/courses/course-v1:MITx+18.6501x+1T2024",
              "video_outline": null,
              "is_self_paced": false
            },
            "certificate": {
              
            },
            "course_modes": [
              {
                "slug": "audit",
                "sku": "4FACA1A",
                "android_sku": null,
                "ios_sku": null
              },
              {
                "slug": "verified",
                "sku": "85B9FCB",
                "android_sku": "mobile.android.85b9fcb",
                "ios_sku": "mobile.ios.85b9fcb"
              }
            ]
          },
          {
            "audit_access_expires": "2024-05-20T23:59:00Z",
            "created": "2024-01-23T07:35:11Z",
            "mode": "audit",
            "is_active": true,
            "course": {
              "id": "course-v1:MITx+6.431x+1T2024",
              "name": "Probability - The Science of Uncertainty and Data",
              "number": "6.431x",
              "org": "MITx",
              "start": "2024-01-29T23:59:00Z",
              "start_display": "Jan. 29, 2024",
              "start_type": "timestamp",
              "end": "2024-05-23T23:59:00Z",
              "dynamic_upgrade_deadline": "2024-03-14T12:00:00Z",
              "subscription_id": "course_MNXXK4TTMUWXMMJ2JVEVI6BLGYXDIMZRPAVTCVBSGAZDI___",
              "courseware_access": {
                "has_access": true,
                "error_code": null,
                "developer_message": null,
                "user_message": null,
                "additional_context_user_message": null,
                "user_fragment": null
              },
              "media": {
                "course_image": {
                  "uri": "/asset-v1:MITx+6.431x+1T2024+type@asset+block@course_image.jpg",
                  "name": "Course Image"
                }
              },
              "course_image": "/asset-v1:MITx+6.431x+1T2024+type@asset+block@course_image.jpg",
              "course_about": "https://www.edx.org/course/probability-the-science-of-uncertainty-and-data-course-v1-mitx-6-431x-1t2024",
              "course_sharing_utm_parameters": {
                "facebook": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=facebook",
                "twitter": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=twitter"
              },
              "course_updates": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:MITx+6.431x+1T2024/updates",
              "course_handouts": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:MITx+6.431x+1T2024/handouts",
              "discussion_url": "https://courses.edx.org/api/discussion/v1/courses/course-v1:MITx+6.431x+1T2024",
              "video_outline": null,
              "is_self_paced": false
            },
            "certificate": {
              
            },
            "course_modes": [
              {
                "slug": "audit",
                "sku": "4273238",
                "android_sku": null,
                "ios_sku": null
              },
              {
                "slug": "verified",
                "sku": "403F90D",
                "android_sku": "mobile.android.403f90d",
                "ios_sku": "mobile.ios.403f90d"
              }
            ]
          },
          {
            "audit_access_expires": "2024-09-09T15:00:00Z",
            "created": "2024-01-20T00:02:13Z",
            "mode": "audit",
            "is_active": true,
            "course": {
              "id": "course-v1:MITx+6.86x+2T2024",
              "name": "Machine Learning with Python: from Linear Models to Deep Learning",
              "number": "6.86x",
              "org": "MITx",
              "start": "2024-05-27T15:00:00Z",
              "start_display": "May 27, 2024",
              "start_type": "timestamp",
              "end": "2024-09-03T15:00:00Z",
              "dynamic_upgrade_deadline": "2024-08-24T23:59:59Z",
              "subscription_id": "course_MNXXK4TTMUWXMMJ2JVEVI6BLGYXDQNTYFMZFIMRQGI2A____",
              "courseware_access": {
                "has_access": false,
                "error_code": "course_not_started",
                "developer_message": "Course does not start until 2024-05-27 15:00:00+00:00",
                "user_message": "Course does not start until May 27, 2024",
                "additional_context_user_message": null,
                "user_fragment": null
              },
              "media": {
                "course_image": {
                  "uri": "/asset-v1:MITx+6.86x+2T2024+type@asset+block@course_image.jpg",
                  "name": "Course Image"
                }
              },
              "course_image": "/asset-v1:MITx+6.86x+2T2024+type@asset+block@course_image.jpg",
              "course_about": "https://www.edx.org/course/machine-learning-with-python-from-linear-models-to-deep-learning-course-v1-mitx-6-86x-2t2024",
              "course_sharing_utm_parameters": {
                "facebook": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=facebook",
                "twitter": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=twitter"
              },
              "course_updates": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:MITx+6.86x+2T2024/updates",
              "course_handouts": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:MITx+6.86x+2T2024/handouts",
              "discussion_url": "https://courses.edx.org/api/discussion/v1/courses/course-v1:MITx+6.86x+2T2024",
              "video_outline": null,
              "is_self_paced": false
            },
            "certificate": {
              
            },
            "course_modes": [
              {
                "slug": "audit",
                "sku": "A962046",
                "android_sku": null,
                "ios_sku": null
              },
              {
                "slug": "verified",
                "sku": "AD41871",
                "android_sku": "mobile.android.ad41871",
                "ios_sku": "mobile.ios.ad41871"
              }
            ]
          },
          {
            "audit_access_expires": null,
            "created": "2024-01-20T00:00:20Z",
            "mode": "audit",
            "is_active": true,
            "course": {
              "id": "course-v1:edX+VideoX+1T2020",
              "name": "VideoX: Creating Video for the edX Platform",
              "number": "VideoX",
              "org": "edX",
              "start": "2020-02-15T17:00:00Z",
              "start_display": "Feb. 15, 2020",
              "start_type": "timestamp",
              "end": "2022-02-03T23:59:00Z",
              "dynamic_upgrade_deadline": null,
              "subscription_id": "course_MNXXK4TTMUWXMMJ2MVSFQK2WNFSGK32YFMYVIMRQGIYA____",
              "courseware_access": {
                "has_access": true,
                "error_code": null,
                "developer_message": null,
                "user_message": null,
                "additional_context_user_message": null,
                "user_fragment": null
              },
              "media": {
                "course_image": {
                  "uri": "/asset-v1:edX+VideoX+1T2020+type@asset+block@course_image.jpg",
                  "name": "Course Image"
                }
              },
              "course_image": "/asset-v1:edX+VideoX+1T2020+type@asset+block@course_image.jpg",
              "course_about": "https://www.edx.org/course/videox-creating-video-for-the-edx-platform-3",
              "course_sharing_utm_parameters": {
                "facebook": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=facebook",
                "twitter": "utm_medium=social&utm_campaign=social-sharing-db&utm_source=twitter"
              },
              "course_updates": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:edX+VideoX+1T2020/updates",
              "course_handouts": "https://courses.edx.org/api/mobile/v3/course_info/course-v1:edX+VideoX+1T2020/handouts",
              "discussion_url": "https://courses.edx.org/api/discussion/v1/courses/course-v1:edX+VideoX+1T2020",
              "video_outline": null,
              "is_self_paced": false
            },
            "certificate": {
              
            },
            "course_modes": [
              {
                "slug": "audit",
                "sku": "99D8FF6",
                "android_sku": null,
                "ios_sku": null
              }
            ]
          }
        ]
      }
    }
    """
}
#endif
// swiftlint:enable all
