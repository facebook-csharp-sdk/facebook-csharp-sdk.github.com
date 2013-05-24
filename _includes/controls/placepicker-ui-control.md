In this document:

* [Title 1](#1)
* [Title 2](#2)
* [Title 3](#3)

---

## Title 1

Text here

---

## Title 2

The following image needs to be in each platform folder. Additionally, this image is centralized.

->![image](images/sample-image.png)<-

---

## Title 3

{% if page.platform == 'phone' %}

The following code is only for phone

    This is code

{% endif %}

{% if page.platform == 'windows' %}

The following code is only for windows

    This is code

{% endif %}
