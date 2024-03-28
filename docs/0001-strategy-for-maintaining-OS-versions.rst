Strategy for maintaining iOS versions in the Open edX Project
#############################################################

Date: 13 September 2023

Status
******
Accepted

Context
*******
In the Open edX project, we are developing a mobile application on the SwiftUI platform for iOS users. 
To ensure optimal support and security of the application, we need to make a decision regarding which 
versions of the iOS operating system will be supported. This document outlines the decision to support 
only the current iOS version and the two previous versions.

Decision
********

We decide to support only the current iOS version and the two previous versions. This means that our
application will be optimized and tested to work on the three most recent iOS versions at the time 
of the application's release.

Why is this important?

1. Streamlined Development and Testing
======================================

Supporting multiple iOS versions requires significant development and testing resources. By restricting 
the number of supported versions, we can focus our efforts on developing new features and improving the 
application's quality, without spreading ourselves too thin trying to maintain compatibility 
with outdated iOS versions.

2. Performance and User Experience Enhancement
==============================================

With each new iOS version, Apple introduces performance and functionality improvements. By limiting support 
to older iOS versions, we can leverage new capabilities and libraries to create faster and more feature-rich 
application versions. This also enhances the user experience and user satisfaction.

3. Security
===========

The most crucial aspect of mobile application development is ensuring user security. New iOS versions 
contain critical security updates, and supporting old iOS versions can leave the application vulnerable 
to known threats. By supporting only the current version and the two previous ones, we can quickly respond 
to security updates and provide robust data protection for users.

Project Impact
**************

This decision will impact the project in the following ways:

- Enhanced application security.
- Improved performance and functionality.
- Reduced development and testing burden.

Implementation
**************

To implement this decision, we will monitor the releases of new iOS versions and update our application 
accordingly, considering the limitation of supporting only the current version and the two previous versions. 
We will also inform users about the need to update their operating systems for optimal application performance.

Alternatives
************

Continuing to support older iOS versions would demand more resources, pose security and performance risks, 
and limit our ability to adopt modern technologies and innovations, potentially slowing down development 
and compromising user experience.
