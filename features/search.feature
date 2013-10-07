Feature: Users can search Gnip-space
    Scenario: User performs a new search
        When I search for obama
        Then the application retrieves activities containing obama
        And the application retrieves counts for obama
