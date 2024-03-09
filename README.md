# UserAccessWithinHierarchy
Business Use Case

When Object wide default is public read only and access has to be given to the logged in user based only on the User Hierarchy, such as the manager or manager’s manager of the record's owner in the hierarchy can also access the quick action. 


Technical Challenges

We can’t provide this type of access using sharing rule or permission set where only managers in the user hierarchy can access the quick action with the owner. We need a custom approach for this.
